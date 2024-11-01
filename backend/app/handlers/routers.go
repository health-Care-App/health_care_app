package handlers

import (
	"app/middleware"
	"app/ws"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

var (
	trustedProxiesAdress = []string{
		"localhost",
		"health-care-app-3e333.web.app",
	}
	allowedOrigins = []string{
		"http://localhost:5000",
		"http://localhost:8888",
		"https://health-care-app-3e333.web.app",
	}
	allowedMethods = []string{
		"POST",
		"GET",
		"OPTIONS",
		"PUT",
		"DELETE",
	}
	allowedHeaders = []string{
		"Content-Type",
		"Content-Length",
		"Accept-Encoding",
		"X-CSRF-Token",
		"Authorization",
	}
)

func Init() {
	r := gin.Default()
	r.ForwardedByClientIP = true
	r.SetTrustedProxies(trustedProxiesAdress)

	authorized := r.Group(rootPath)
	authorized.Use(middleware.Authorized())
	{
		authorized.GET(healthPath, gethealthHandler)
		authorized.POST(healthPath, postHealthHandler)
		authorized.GET(sleepTimePath, getSleepTimeHandler)
		authorized.POST(sleepTimePath, postSleepTimeHandler)
		authorized.GET(messagePath, getMessageHandler)
		authorized.POST(messagePath, postMessageHandler)
	}

	// CORS対策
	authorized.Use(cors.New(cors.Config{
		AllowOrigins: allowedOrigins,
		AllowMethods: allowedMethods,
		AllowHeaders: allowedHeaders,

		//cookieを送受信するか
		AllowCredentials: isAllowdCookie,

		//Cookieの期限
		MaxAge: cookieExpire,
	}))

	//wsの認証は別に仕組みを持つ
	wsAuthorized := r.Group(rootPath)
	wsAuthorized.Use(middleware.WsAuthorized())
	{
		wsAuthorized.GET(wsPath, ws.Wshandler)
	}
	r.Run(port)
}
