package common

import "time"

type (
	Healths struct {
		Id     string    `json:"id" validate:"required"`
		Date   time.Time `json:"dateTime" validate:"required"`
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
		Date      time.Time `json:"dateTime" validate:"required"`
		SleepTime int       `json:"sleepTime" validate:"min=0,max=24"`
	}

	SleepTimeGetResponse struct {
		SleepTimes []SleepTimes `json:"sleepTimes" validate:"required"`
	}

	Messages struct {
		Id       string    `json:"id" validate:"required"`
		Date     time.Time `json:"dateTime" validate:"required"`
		Question string    `json:"question" validate:"required"`
		Answer   string    `json:"answer" validate:"required"`
	}

	MessageGetResponse struct {
		Messages []Messages `json:"messages" validate:"required"`
	}

	WsResponse struct {
		Base64Data string `json:"base64Data" validate:"omitempty"`
		Text       string `json:"text" validate:"omitempty"`
		SpeakerId  uint   `json:"speakerId" validate:"omitempty"`
	}

	ErrResponse struct {
		Error string `json:"error" validate:"required"`
	}
)
