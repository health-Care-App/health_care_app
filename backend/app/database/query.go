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

	PostMessageDataQuery struct {
		Who  string    `json:"who" validate:"required,oneof=user system"`
		Text string    `json:"text" validate:"required"`
		Date time.Time `json:"Date" validate:"required"`
	}
)
