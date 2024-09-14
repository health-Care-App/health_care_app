package handlers

type (
	HealthPostRequestBody struct {
		UserId string `json:"userId" binding:"required"`
		Health int    `json:"health" binding:"required"`
	}

	SleepTimePostRequestBody struct {
		UserId    string `json:"userId" binding:"required"`
		SleepTime int    `json:"sleepTime" binding:"required"`
	}
)
