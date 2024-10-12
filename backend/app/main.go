package main

import (
	"app/handlers"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	//開発環境、本番環境によって処理を分岐
	if _, isDev := os.LookupEnv("FIRESTORE_EMULATOR_HOST"); !isDev {
		gin.SetMode(gin.ReleaseMode)
	} else {
		gin.SetMode(gin.DebugMode)
	}

	handlers.Init()
}
