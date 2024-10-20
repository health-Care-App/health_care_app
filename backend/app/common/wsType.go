package common

//リクエスト
type Message struct {
	Question string `json:"question" validate:"required"`
	//ずんだもんの場合0, 春日部つむぎの場合1
	SynthModel int `json:"synth_model" validate:"min=0,max=1"`
	//chatGPTの場合0, geminiの場合1
	ChatModel int `json:"chat_model" validate:"min=0,max=1"`
	//trueの場合音声合成を行う。falseの場合は音声は送らずテキストとspeaker_idのみをレスポンスとする
	IsSynth bool `json:"is_synth"`
}
