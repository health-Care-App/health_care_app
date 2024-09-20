package handlers

import (
	"app/common"
	"app/database"
	"app/validate"
	"time"

	"github.com/gin-gonic/gin"
)

const (
	port            = ":8080"
	defaultWeekTerm = 7
)

// 健康状態を取得する関数
func gethealthHandler(c *gin.Context) {
	getHandler(c, database.GetHealthData)
}

// 健康状態を保存する関数
func postHealthHandler(c *gin.Context) {
	userId := common.NewUserId(c)

	body := HealthPostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		common.ErrorResponse(c, err)
		return
	}

	createDateAt := time.Now()
	queryData := database.HealthsDoc{
		Health: body.Health,
		Date:   createDateAt,
	}

	//データが正しいか検証
	if err := validate.Validation(queryData); err != nil {
		common.ErrorResponse(c, err)
		return
	}

	response, err := database.PostHelthData(userId, queryData)
	if err != nil {
		common.ErrorResponse(c, err)
		return
	}

	c.JSON(200, response)
}

// 睡眠時間を取得する関数
func getSleepTimeHandler(c *gin.Context) {
	getHandler(c, database.GetSleepTimeData)
}

// 睡眠時間を保存する関数
func postSleepTimeHandler(c *gin.Context) {
	userId := common.NewUserId(c)

	body := SleepTimePostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		common.ErrorResponse(c, err)
		return
	}

	createDateAt := time.Now()
	queryData := database.SleepTimesDoc{
		SleepTime: body.SleepTime,
		Date:      createDateAt,
	}

	//データが正しいか検証
	if err := validate.Validation(queryData); err != nil {
		common.ErrorResponse(c, err)
		return
	}

	response, err := database.PostSleepTimeData(userId, queryData)
	if err != nil {
		common.ErrorResponse(c, err)
		return
	}
	c.JSON(200, response)
}

// メッセージを取得する関数
func getMessageHandler(c *gin.Context) {
	getHandler(c, database.GetMessageData)
}

// GETハンドラを共通化
func getHandler[T database.HealthGetResponse | database.SleepTimeGetResponse | database.MessageGetResponse](c *gin.Context, getData func(string, time.Time) (T, error)) {
	userId := common.NewUserId(c)

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -defaultWeekTerm).Format(common.Layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(common.Layout, oldDateAt)
	if err != nil {
		common.ErrorResponse(c, err)
		return
	}

	response, err := getData(userId, ParsedOldDateAt)
	if err != nil {
		common.ErrorResponse(c, err)
		return
	}

	c.JSON(200, response)
}
