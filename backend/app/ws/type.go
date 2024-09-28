package ws

type Audio struct {
	Audiobytes []byte `validate:"required"`
	Number     int    `validate:"required"`
}
