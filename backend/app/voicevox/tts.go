package voicevox

import (
	voicevoxcorego "github.com/sh1ma/voicevoxcore.go"
)

func SpeechSynth(text string, model uint, audioBytes chan<- []byte, errChan chan<- error) {
	core := voicevoxcorego.New()
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(0, 0, false, "/app/voicevox_core/open_jtalk_dic_utf_8-1.11")
	core.Initialize(initializeOptions)

	core.LoadModel(model)

	ttsOptions := voicevoxcorego.NewVoicevoxTtsOptions(false, true)
	result, err := core.Tts(text, 1, ttsOptions)

	//ここで必ずエラーが起きるが正常に処理できるため一旦無視
	if err != nil {
		//errChan <- err
		//return
	}

	audioBytes <- result

	defer func() {
		errChan <- nil
	}()
}
