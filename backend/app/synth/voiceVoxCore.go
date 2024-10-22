package synth

import (
	voicevoxcorego "github.com/sh1ma/voicevoxcore.go"
)

func VoiceVoxCoreSynth(ttsText TtsText) ([]byte, error) {
	core := voicevoxcorego.New()

	//`VoiceVoxCore`の初期化オプションを生成する関数
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(accelerationMode, cpuNumThreads, loadAllModels, openJtalkDictDir)
	core.Initialize(initializeOptions)
	core.LoadModel(ttsText.SpeakerId)

	//オーディオクエリ生成
	audioQueryOption := voicevoxcorego.NewVoicevoxAudioQueryOptions(kana)
	audioQuery, err := core.AudioQuery(ttsText.Text, ttsText.SpeakerId, audioQueryOption)
	if err != nil {
		return nil, err
	}

	//audioQuery調整
	audioQuery.SpeedScale = speechspeed

	//音声合成
	synthesisOption := voicevoxcorego.NewVoicevoxSynthesisOptions(enableInterrogativeUpspeak)
	result, err := core.Synthesis(audioQuery, int(ttsText.SpeakerId), synthesisOption)
	if err != nil {
		return nil, nil
	}

	return result, nil
}
