package database

import "time"

type (
	Dict map[string]interface{}

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
		Id   string    `json:"id" validate:"required"`
		Who  string    `json:"who" validate:"required,oneof=user system"`
		Date time.Time `json:"Date" validate:"required"`
		Text string    `json:"text" validate:"required"`
	}

	MessageGetResponse struct {
		Messages []Messages `json:"messages" validate:"required"`
	}
)
