package handlers

import (
	"app/middleware"
	"app/websocket"

	"github.com/gin-gonic/gin"
)

const (
	//endPoint定義
	rootPath      = "/"
	healthPath    = "/health"
	sleepTimePath = "/sleepTime"
	messagePath   = "/message"
	wsPath        = "/ws"
)

func Initializer() {
	r := gin.Default()
	authorized := r.Group(rootPath)

	authorized.Use(middleware.Authorized())
	{
		authorized.GET(healthPath, gethealthHandler)
		authorized.POST(healthPath, postHealthHandler)
		authorized.GET(sleepTimePath, getSleepTimeHandler)
		authorized.POST(sleepTimePath, postSleepTimeHandler)
		authorized.GET(messagePath, getMessageHandler)
		authorized.GET(wsPath, websocket.Wshandler)
	}
	r.Run(port)
}
