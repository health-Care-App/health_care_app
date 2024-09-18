package database

import "time"

type (
	Healths struct {
		Id     string    `json:"id" validate:"required"`
		Date   time.Time `json:"Date" validate:"required"`
		Health int       `json:"health" validate:"required"`
	}

	HealthGetResponse struct {
		Healths []Healths `json:"healths" validate:"required"`
	}

	PostResponse struct {
		Message string `json:"message" validate:"required"`
	}

	SleepTimes struct {
		Id        string    `json:"id" validate:"required"`
		Date      time.Time `json:"Date" validate:"required"`
		SleepTime int       `json:"sleep_time" validate:"required"`
	}

	SleepTimeGetResponse struct {
		SleepTimes []SleepTimes `json:"sleep_times" validate:"required"`
	}

	Messages struct {
		Id       string    `json:"id" validate:"required"`
		Date     time.Time `json:"Date" validate:"required"`
		Question string    `json:"question" validate:"required"`
		Answer   string    `json:"answer" validate:"required"`
	}

	MessageGetResponse struct {
		Messages []Messages `json:"messages" validate:"required"`
	}
)
