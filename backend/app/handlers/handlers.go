package handlers

import (
	"app/database"
	"time"

	"github.com/gin-gonic/gin"
)

const (
	layout = "2006-01-02"
	port   = ":8080"
)

// 健康状態を取得する関数
func gethealthHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		userErrorResponse(c)
	}
	userId := value.(string)

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -7).Format(layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		errorResponse(c, err)
	}

	response, err := database.GetHealthData(userId, ParsedOldDateAt)
	if err != nil {
		errorResponse(c, err)
	}

	c.JSON(200, response)
}

// 健康状態を保存する関数
func postHealthHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		userErrorResponse(c)
	}
	userId := value.(string)

	body := HealthPostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		errorResponse(c, err)
	}
	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		errorResponse(c, err)
	}

	response, err := database.PostHelthData(
		userId,
		database.PostHelthDataQuery{
			Health: body.Health,
			Date:   createDateAt,
		},
	)
	if err != nil {
		errorResponse(c, err)
	}

	c.JSON(200, response)
}

// 睡眠時間を取得する関数
func getSleepTimeHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		userErrorResponse(c)
	}
	userId := value.(string)

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -7).Format(layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		errorResponse(c, err)
	}

	response, err := database.GetSleepTimeData(userId, ParsedOldDateAt)
	if err != nil {
		errorResponse(c, err)
	}
	c.JSON(200, response)
}

// 睡眠時間を保存する関数
func postSleepTimeHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		userErrorResponse(c)
	}
	userId := value.(string)

	body := SleepTimePostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		errorResponse(c, err)
	}

	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		errorResponse(c, err)
	}

	response, err := database.PostSleepTimeData(
		userId,
		database.PostSleepTimeDataQuery{
			SleepTime: body.SleepTime,
			Date:      createDateAt,
		})
	if err != nil {
		errorResponse(c, err)
	}
	c.JSON(200, response)
}

// メッセージを取得する関数
func getMessageHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		userErrorResponse(c)
	}
	userId := value.(string)

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -7).Format(layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		errorResponse(c, err)
	}

	response, err := database.GetMessageData(userId, ParsedOldDateAt)
	if err != nil {
		errorResponse(c, err)
	}
	c.JSON(200, response)
}
