package database

import "time"

type (
	HealthsDoc struct {
		Health int       `json:"health" validate:"required"`
		Date   time.Time `json:"Date" validate:"required"`
	}

	SleepTimesDoc struct {
		SleepTime int       `json:"sleep_time" validate:"required"`
		Date      time.Time `json:"Date" validate:"required"`
	}

	MessagesDoc struct {
		Who  string    `json:"who" validate:"required,oneof=user system"`
		Text string    `json:"text" validate:"required"`
		Date time.Time `json:"Date" validate:"required"`
	}
)
