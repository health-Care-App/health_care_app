package handlers

import (
	"app/database"
	"log"
	"time"

	"github.com/gin-gonic/gin"
)

const (
	//endPoint定義
	healthPath        = "/health"
	postHealthPath    = healthPath
	getHealthPath     = healthPath + "/:userId"
	sleepTimePath     = "/sleepTime"
	getSleepTimePath  = sleepTimePath + "/:userId"
	postSleepTimePath = sleepTimePath
	messagePath       = "/message"
	getMessagePath    = messagePath + "/:userId"

	layout = "2006-01-02"
)

type (
	healthPostRequestBody struct {
		UserId string `json:"userId" binding:"required"`
		Health int    `json:"health" binding:"required"`
	}

	sleepTimePostRequestBody struct {
		UserId    string `json:"userId" binding:"required"`
		SleepTime int    `json:"sleepTime" binding:"required"`
	}
)

// 健康状態を取得する関数
func gethealthHandler(c *gin.Context) {
	userId := c.Param("userId")

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -7).Format(layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		log.Fatalln(err)
	}
	response := database.GetHealthData(userId, ParsedOldDateAt)
	c.JSON(200, response)
}

// 健康状態を保存する関数
func postHealthHandler(c *gin.Context) {
	body := healthPostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		log.Fatalln(err)
	}
	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		log.Fatalln(err)
	}
	response := database.PostHelthData(body.UserId, body.Health, createDateAt)
	c.JSON(200, response)
}

// 睡眠時間を取得する関数
func getSleepTimeHandler(c *gin.Context) {
	userId := c.Param("userId")

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -7).Format(layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		log.Fatalln(err)
	}
	response := database.GetSleepTimeData(userId, ParsedOldDateAt)
	c.JSON(200, response)
}

// 睡眠時間を保存する関数
func postSleepTimeHandler(c *gin.Context) {
	body := sleepTimePostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		log.Fatalln(err)
	}
	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		log.Fatalln(err)
	}
	response := database.PostSleepTimeData(body.UserId, body.SleepTime, createDateAt)
	c.JSON(200, response)
}

// メッセージを取得する関数
func getMessageHandler(c *gin.Context) {
	userId := c.Param("userId")

	//現在の1週間前をdefaultとする
	defaultDate := time.Now().AddDate(0, 0, -7).Format(layout)
	oldDateAt := c.DefaultQuery("oldDateAt", defaultDate)
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		log.Fatalln(err)
	}
	response := database.GetMessageData(userId, ParsedOldDateAt)
	c.JSON(200, response)
}

func Initializer() {
	r := gin.Default()
	r.GET(getHealthPath, gethealthHandler)
	r.POST(postHealthPath, postHealthHandler)
	r.GET(getSleepTimePath, getSleepTimeHandler)
	r.POST(postSleepTimePath, postSleepTimeHandler)
	r.GET(getMessagePath, getMessageHandler)
	r.Run()
}
