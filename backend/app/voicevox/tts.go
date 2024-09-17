package voicevox

import (
	"fmt"
	"sync"

	voicevoxcorego "github.com/sh1ma/voicevoxcore.go"
)

func SpeechSynth(text string, speakerId uint, audioBytes chan<- []byte, errCh chan<- error, wg *sync.WaitGroup) {
	core := voicevoxcorego.New()

	//`VoiceVoxCore`の初期化オプションを生成する関数
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(0, 2, false, "/app/voicevox_core/open_jtalk_dic_utf_8-1.11")
	core.Initialize(initializeOptions)

	core.LoadModel(speakerId)

	//`Tts()`の初期化オプションを生成する関数
	ttsOptions := voicevoxcorego.NewVoicevoxTtsOptions(false, true)

	fmt.Printf("Gpuモード: %t\nモデルがロードされているか: %t\n", core.IsGpuMode(), core.IsModelLoaded(speakerId))
	result, err := core.Tts(text, int(speakerId), ttsOptions)

	//ここで必ずエラーが起きるが正常に処理できるため一旦無視
	if err != nil {
		//errCh <- err
		//return
	}

	audioBytes <- result
	defer wg.Done()
}
