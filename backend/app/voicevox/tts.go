package voicevox

import (
	"fmt"
	"sync"

	voicevoxcorego "github.com/sh1ma/voicevoxcore.go"
)

func SpeechSynth(text string, wg *sync.WaitGroup, audioBytes chan<- []byte) {

	core := voicevoxcorego.New()
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(0, 0, false, "/app/voicevox_core/open_jtalk_dic_utf_8-1.11")
	core.Initialize(initializeOptions)

	core.LoadModel(3)

	ttsOptions := voicevoxcorego.NewVoicevoxTtsOptions(false, true)
	result, err := core.Tts(text, 1, ttsOptions)

	if err != nil {
		fmt.Println(err)
	}
	audioBytes <- result

	wg.Done()
}
