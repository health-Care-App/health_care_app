package voicevox

import (
	voicevoxcorego "github.com/sh1ma/voicevoxcore.go"
)

const (
	accelerationMode = 0
	cpuNumThreads    = 1 //「cpu_numhreadsが未指定または0」の場合は、「論理コア数の半分」の値を渡す
	loadAllModels    = false
	openJtalkDictDir = `/app/voicevox_core/open_jtalk_dic_utf_8-1.11`

	kana = false

	enableInterrogativeUpspeak = true
)

type Audio struct {
	Audiobytes []byte `validate:"required"`
	Text       string `validate:"required"`
	speakerId  int    `validate:"required"`
}

type TtsWaitText struct {
	Text      string
	SpeakerId uint
}

func SpeechSynth(text string, speakerId uint) (Audio, error) {
	core := voicevoxcorego.New()

	//`VoiceVoxCore`の初期化オプションを生成する関数
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(accelerationMode, cpuNumThreads, loadAllModels, openJtalkDictDir)
	core.Initialize(initializeOptions)
	core.LoadModel(speakerId)

	//オーディオクエリ生成
	audioQueryOption := voicevoxcorego.NewVoicevoxAudioQueryOptions(kana)
	audioQuery, err := core.AudioQuery(text, speakerId, audioQueryOption)
	if err != nil {
		return Audio{}, err
	}

	//audioQuery調整
	audioQuery.SpeedScale = 1.05

	//音声合成
	synthesisOption := voicevoxcorego.NewVoicevoxSynthesisOptions(enableInterrogativeUpspeak)
	result, err := core.Synthesis(audioQuery, int(speakerId), synthesisOption)

	//ここで必ずエラーが起きるが正常に処理できるため一旦無視
	if err != nil {
		return Audio{}, nil
	}

	return Audio{
		Audiobytes: result,
		Text:       text,
		speakerId:  int(speakerId),
	}, nil
}
