package handlers

import (
	"app/chat"
	"app/common"
	"app/synth"
	"app/validate"
	"encoding/base64"
	"fmt"
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
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	createDateAt := time.Now()
	queryData := common.HealthsDoc{
		Health: body.Health,
		Date:   createDateAt,
	}

	//データが正しいか検証
	if err := validate.Validation(queryData); err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	response, err := common.PostHelthData(userId, queryData)
	if err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	c.JSON(successCode, response)
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
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	createDateAt := time.Now()
	queryData := common.SleepTimesDoc{
		SleepTime: body.SleepTime,
		Date:      createDateAt,
	}

	//データが正しいか検証
	if err := validate.Validation(queryData); err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	response, err := common.PostSleepTimeData(userId, queryData)
	if err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}
	c.JSON(successCode, response)
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
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	response, err := getData(userId, ParsedOldDateAt)
	if err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	c.JSON(successCode, response)
}

func postMessageHandler(c *gin.Context) {
	userId := common.NewUserId(c)
	body := common.Message{}

	if err := c.ShouldBind(&body); err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
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
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	var audio synth.Audio
	var base64Data string
	//リクエストパラメータ"is_synth"がtrueの場合音声合成を行う
	if body.IsSynth {
		audio, err = synth.VoiceVoxApiSynth(ttsText)
		if err != nil {
			common.ErrorResponse(c, err, common.InternalErrCode)
			return
		}

		base64Data = base64.StdEncoding.EncodeToString(audio.Audiobytes)
	} else {
		//音声合成を行わない場合空文字を返す
		base64Data = ""
	}

	response := common.WsResponse{
		Base64Data: base64Data,
		Text:       ttsText.Text,
		SpeakerId:  ttsText.SpeakerId,
	}

	//データが正しいか検証
	if err := validate.Validation(response); err != nil {
		common.ErrorResponse(c, err, common.InternalErrCode)
		return
	}

	c.JSON(successCode, response)
}
