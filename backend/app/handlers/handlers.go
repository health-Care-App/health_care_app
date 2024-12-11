package handlers

import (
	"app/chat"
	"app/common"
	"app/synth"
	"app/validate"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

// 健康状態を取得する関数
func gethealthHandler(c *gin.Context) {
	getHandler(c, common.GetHealthData)
}

// 健康状態を保存する関数
func postHealthHandler(c *gin.Context) {
	userId := common.NewUserId(c)

	body := common.HealthPostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	createDateAt := time.Now()
	queryData := common.HealthsDoc{
		Health: body.Health,
		Date:   createDateAt,
	}

	//データが正しいか検証
	if err := validate.Validation(queryData); err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	response, err := common.PostHelthData(userId, queryData)
	if err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, response)
}

// 睡眠時間を取得する関数
func getSleepTimeHandler(c *gin.Context) {
	getHandler(c, common.GetSleepTimeData)
}

// 睡眠時間を保存する関数
func postSleepTimeHandler(c *gin.Context) {
	userId := common.NewUserId(c)

	body := common.SleepTimePostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	createDateAt := time.Now()
	queryData := common.SleepTimesDoc{
		SleepTime: body.SleepTime,
		Date:      createDateAt,
	}

	//データが正しいか検証
	if err := validate.Validation(queryData); err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	response, err := common.PostSleepTimeData(userId, queryData)
	if err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, response)
}

// メッセージを取得する関数
func getMessageHandler(c *gin.Context) {
	getHandler(c, common.GetMessageData)
}

// GETハンドラを共通化
func getHandler[T common.HealthGetResponse | common.SleepTimeGetResponse | common.MessageGetResponse](c *gin.Context, getData func(string, time.Time) (T, error)) {
	userId := common.NewUserId(c)

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -defaultWeekTerm).Format(common.Layout)
	oldDateAt := c.DefaultQuery(oldDateAtParam, defaultDate)
	ParsedOldDateAt, err := time.Parse(common.Layout, oldDateAt)
	if err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	response, err := getData(userId, ParsedOldDateAt)
	if err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, response)
}

func postMessageHandler(c *gin.Context) {
	userId := common.NewUserId(c)
	body := common.Message{}

	if err := c.ShouldBind(&body); err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	var ttsText synth.TtsText
	var err error
	if body.ChatModel == 0 {
		//chatGPTで対話
		fmt.Println("chatGPT called")
		ttsText, err = chat.GptChatApi(body, userId)
	} else {
		//geminiで対話
		fmt.Println("gemini called")
		ttsText, err = chat.GeminiChatApi(body, userId)
	}
	if err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	base64Data, err := synth.TextToBase64(body.IsSynth, ttsText)
	if err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	response := common.WsResponse{
		Base64Data: base64Data,
		Text:       ttsText.Text,
		SpeakerId:  ttsText.SpeakerId,
	}

	//データが正しいか検証
	if err := validate.Validation(response); err != nil {
		common.ErrorResponse(c, err, http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, response)
}

func optionsHander(c *gin.Context) {
	//許可されているオリジンかどうか検査
	origin := c.GetHeader("Origin")
	for _, allowedHeader := range allowedHeaders {
		if allowedHeader == origin {
			c.Header("Access-Control-Allow-Origin", origin)
			c.Header("Access-Control-Allow-Methods", strings.Join(allowedMethods, ", "))
			c.Header("Access-Control-Allow-Headers", strings.Join(allowedHeaders, ", "))
			c.Header("Access-Control-Allow-Credentials", strconv.FormatBool(isAllowdCookie))
			c.Header("Access-Control-Max-Age", strconv.Itoa(int(cookieExpire)))
			c.JSON(http.StatusNoContent, nil) //204を返す
		}
	}

	//許可されていないオリジンの場合ステータスコード400を返す
	c.JSON(http.StatusBadRequest, nil)
}
