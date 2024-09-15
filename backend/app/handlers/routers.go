package handlers

import (
	"app/middleware"
	"app/ws"
	"time"

	"github.com/gin-contrib/cors"
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

	// CORS対策
	authorized.Use(cors.New(cors.Config{
		AllowOrigins: []string{
			"http://localhost:5000",
			"http://localhost:8888",
			"https://health-care-app-3e333.web.app",
		},
		AllowMethods: []string{
			"POST",
			"GET",
			"OPTIONS",
			"PUT",
			"DELETE",
		},
		AllowHeaders: []string{
			"Content-Type",
			"Content-Length",
			"Accept-Encoding",
			"X-CSRF-Token",
			"Authorization",
		},

		//cookie
		AllowCredentials: true,
		MaxAge:           24 * time.Hour,
	}))

	authorized.Use(middleware.Authorized())
	{
		authorized.GET(healthPath, gethealthHandler)
		authorized.POST(healthPath, postHealthHandler)
		authorized.GET(sleepTimePath, getSleepTimeHandler)
		authorized.POST(sleepTimePath, postSleepTimeHandler)
		authorized.GET(messagePath, getMessageHandler)
		authorized.GET(wsPath, ws.Wshandler)
	}
	r.Run(port)
}
