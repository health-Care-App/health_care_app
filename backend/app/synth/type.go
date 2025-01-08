package synth

type TtsText struct {
	Text      string `validate:"required"`
	SpeakerId uint   `validate:"required"`
}
