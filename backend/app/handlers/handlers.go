package handlers

import (
	"app/database"
	"log"
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
		log.Fatalln("User is not exist")
	}
	userId := value.(string)

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
	value, exists := c.Get("userId")
	if !exists {
		log.Fatalln("User is not exist")
	}
	userId := value.(string)

	body := HealthPostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		log.Fatalln(err)
	}
	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		log.Fatalln(err)
	}
	response := database.PostHelthData(userId, body.Health, createDateAt)
	c.JSON(200, response)
}

// 睡眠時間を取得する関数
func getSleepTimeHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		log.Fatalln("user is not exist.")
	}
	userId := value.(string)

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
	value, exists := c.Get("userId")
	if !exists {
		log.Fatalln("User is not exist")
	}
	userId := value.(string)

	body := SleepTimePostRequestBody{}
	if err := c.ShouldBind(&body); err != nil {
		log.Fatalln(err)
	}
	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		log.Fatalln(err)
	}
	response := database.PostSleepTimeData(userId, body.SleepTime, createDateAt)
	c.JSON(200, response)
}

// メッセージを取得する関数
func getMessageHandler(c *gin.Context) {
	value, exists := c.Get("userId")
	if !exists {
		log.Fatalln("user is not exist.")
	}
	userId := value.(string)

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