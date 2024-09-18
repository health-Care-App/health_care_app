package database

import "time"

type (
	HealthsDoc struct {
		Health int       `json:"health" firestore:"health" validate:"required"`
		Date   time.Time `json:"Date" firestore:"Date" validate:"required"`
	}

	SleepTimesDoc struct {
		SleepTime int       `json:"sleep_time" firestore:"sleep_time" validate:"required"`
		Date      time.Time `json:"Date" firestore:"Date" validate:"required"`
	}

	MessagesDoc struct {
		Question string    `json:"question" firestore:"question" validate:"required"`
		Answer   string    `json:"answer" firestore:"answer" validate:"required"`
		Date     time.Time `json:"Date" firestore:"Date" validate:"required"`
	}
)
