package voicevox

import (
	"sync"

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
	Number     int    `validate:"required"`
}

func SpeechSynth(text string, speakerId uint, audioCh chan<- Audio, errCh chan<- error, wg *sync.WaitGroup, audioCounter int) {
	defer wg.Done()

	core := voicevoxcorego.New()

	//`VoiceVoxCore`の初期化オプションを生成する関数
	initializeOptions := voicevoxcorego.NewVoicevoxInitializeOptions(accelerationMode, cpuNumThreads, loadAllModels, openJtalkDictDir)
	core.Initialize(initializeOptions)
	core.LoadModel(speakerId)

	//オーディオクエリ生成
	audioQueryOption := voicevoxcorego.NewVoicevoxAudioQueryOptions(kana)
	audioQuery, err := core.AudioQuery(text, speakerId, audioQueryOption)
	if err != nil {
		//errCh <- err
		//return
	}

	//audioQuery調整
	audioQuery.SpeedScale = 1.05

	//音声合成
	synthesisOption := voicevoxcorego.NewVoicevoxSynthesisOptions(enableInterrogativeUpspeak)
	result, err := core.Synthesis(audioQuery, int(speakerId), synthesisOption)

	//ここで必ずエラーが起きるが正常に処理できるため一旦無視
	if err != nil {
		//errCh <- err
		//return
	}

	audioCh <- Audio{
		Audiobytes: result,
		Number:     audioCounter,
	}
}
