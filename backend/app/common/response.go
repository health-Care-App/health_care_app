package common

import "time"

type (
	Healths struct {
		Id     string    `json:"id" validate:"required"`
		Date   time.Time `json:"Date" validate:"required"`
		Health int       `json:"health" validate:"min=1,max=10"`
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
		SleepTime int       `json:"sleep_time" validate:"min=0,max=24"`
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

	WsResponse struct {
		Base64Data string `json:"base64_data" validate:"omitempty"`
		Text       string `json:"text" validate:"omitempty"`
		SpeakerId  uint   `json:"speaker_id" validate:"omitempty"`
	}

	ErrResponse struct {
		Error string `json:"error" validate:"required"`
	}
)
