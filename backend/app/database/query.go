package database

import "time"

type (
	PostHelthDataQuery struct {
		Health int       `json:"health" validate:"required"`
		Date   time.Time `json:"Date" validate:"required"`
	}

	PostSleepTimeDataQuery struct {
		SleepTime int       `json:"sleep_time" validate:"required"`
		Date      time.Time `json:"Date" validate:"required"`
	}
)
