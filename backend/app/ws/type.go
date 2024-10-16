package ws

type WsResponse struct {
	Base64Data string `json:"base64_data" validate:"required"`
	Text       string `json:"text" validate:"required"`
	SpeakerId  uint   `json:"speaker_id" validate:"required"`
}
