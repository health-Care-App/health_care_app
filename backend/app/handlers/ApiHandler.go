package handlers

import (
	"github.com/gin-gonic/gin"
)

const (
	//endPoint定義
	healthPath        = "/health"
	healthPostPath    = healthPath
	healthGetPath     = healthPath + "/:userId"
	sleepTimePath     = "/sleepTime"
	sleepTimeGetPath  = sleepTimePath + "/:userId"
	sleepTimePostPath = sleepTimePath
	messagePath       = "/message"
	messageGetPath    = messagePath + "/:userId"
)

func healthGetHandler(c *gin.Context) {
	//健康状態を取得する処理
}

func healthPostHandler(c *gin.Context) {
	//健康状態を保存する処理
}

func sleepTimeGetHandler(c *gin.Context) {
	//睡眠時間を取得する処理
}

func sleepTimePostHandler(c *gin.Context) {
	//睡眠時間を保存する処理
}

func messageGetHandler(c *gin.Context) {
	//メッセージを取得する処理
}

func Initializer() {
	r := gin.Default()
	r.GET(healthGetPath, healthGetHandler)
	r.POST(healthPostPath, healthPostHandler)
	r.GET(sleepTimeGetPath, sleepTimeGetHandler)
	r.POST(sleepTimePostPath, sleepTimePostHandler)
	r.GET(messageGetPath, messageGetHandler)
	r.Run()
}
