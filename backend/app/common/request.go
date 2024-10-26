package common

type (
	HealthPostRequestBody struct {
		Health int `json:"health" validate:"required"`
	}

	SleepTimePostRequestBody struct {
		SleepTime int `json:"sleepTime" validate:"required"`
	}

	Message struct {
		Question string `json:"question" validate:"required"`
		//ずんだもんの場合0, 春日部つむぎの場合1
		SynthModel int `json:"synthModel" validate:"min=0,max=1"`
		//chatGPTの場合0, geminiの場合1
		ChatModel int `json:"chatModel" validate:"min=0,max=1"`
		//trueの場合音声合成を行う。falseの場合は音声は送らずテキストとspeaker_idのみをレスポンスとする
		IsSynth bool `json:"isSynth"`
	}
)
