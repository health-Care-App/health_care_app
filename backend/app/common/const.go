package common

import "time"

// 外部package用
const (
	Layout          = time.RFC3339
	LineTextPattern = `<m(\d+)>(.+)<\/m(\d+)>`
	MaxTokensLength = 500
	AddStep         = 1
	InternalErrCode = 500
	ExternalErrCode = 401
)

// firestore
const (
	healthCollec       = "health"
	healthSubCollec    = "healths"
	sleepTimeCollec    = "sleepTime"
	sleepTimeSubCollec = "sleepTimes"
	messageCollec      = "message"
	messageSubCollec   = "messages"
	statusOk           = "ok"
)
