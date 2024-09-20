package handlers

import "time"

const (
	defaultWeekTerm = 7
	oldDateAtParam  = "oldDateAt"

	//endPoint定義
	rootPath      = "/"
	healthPath    = "/health"
	sleepTimePath = "/sleepTime"
	messagePath   = "/message"
	wsPath        = "/ws"

	isAllowdCookie = true
	cookieExpire   = 24 * time.Hour

	port = ":8080"
)
