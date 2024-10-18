package ws

type WsResponse struct {
	Base64Data string `json:"base64_data" validate:"omitempty"`
	Text       string `json:"text" validate:"omitempty"`
	SpeakerId  uint   `json:"speaker_id" validate:"omitempty"`
}
