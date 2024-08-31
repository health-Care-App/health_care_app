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
)

// 健康状態を取得する関数
func gethealthHandler(c *gin.Context) {
	layout := "2006-01-02"
	userId := c.Param("userId")
	oldDateAt := c.DefaultQuery("oldDateAt", time.Now().Format(layout))
	ParsedOldDateAt, err := time.Parse(layout, oldDateAt)
	if err != nil {
		log.Fatalln(err)
	}
	database.GetHealthData(userId, ParsedOldDateAt)
}

// 健康状態を保存する関数
func postHealthHandler(c *gin.Context) {

}

// 睡眠時間を取得する関数
func getSleepTimeHandler(c *gin.Context) {

}

// 睡眠時間を保存する関数
func postSleepTimeHandler(c *gin.Context) {

}

// メッセージを取得する関数
func getMessageHandler(c *gin.Context) {

}

func Initializer() {
	r := gin.Default()
	r.GET(getHealthPath, gethealthHandler)
	r.POST(postHealthPath, postHealthHandler)
	r.GET(postSleepTimePath, getSleepTimeHandler)
	r.POST(postSleepTimePath, postSleepTimeHandler)
	r.GET(getMessagePath, getMessageHandler)
	r.Run()
}
