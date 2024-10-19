package common

type (
	HealthPostRequestBody struct {
		Health int `json:"health" validate:"required"`
	}

	SleepTimePostRequestBody struct {
		SleepTime int `json:"sleepTime" validate:"required"`
	}
)
