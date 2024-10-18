package synth

type TtsText struct {
	Text      string `validate:"required"`
	SpeakerId uint   `validate:"required"`
}

type Audio struct {
	Audiobytes []byte  `validate:"required"`
	TtsText    TtsText `validate:"required"`
}
