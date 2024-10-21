package ws

import (
	"app/common"
	"app/synth"
	"app/validate"
	"encoding/base64"
	"fmt"
	"sync"

	"github.com/gorilla/websocket"
)

func sendJson(isSynth bool, ttsText synth.TtsText, wg *sync.WaitGroup, conn *websocket.Conn, errCh chan<- error) {
	var base64Data string
	if isSynth {
		audio, err := queueToSynthFunc(ttsText, synth.VoiceVoxApiSynth)
		if err != nil {
			errCh <- err
		}
		base64Data = base64.StdEncoding.EncodeToString(audio.Audiobytes)
	} else {
		base64Data = ""
	}
	wg.Done()

	wsResponse := common.WsResponse{
		Base64Data: base64Data,
		Text:       ttsText.Text,
		SpeakerId:  ttsText.SpeakerId,
	}

	if err := validate.Validation(wsResponse); err != nil {
		errCh <- err
		return
	}

	conn.WriteJSON(wsResponse)
}

func readJson(isProcessing *bool, conn *websocket.Conn, messageCh chan<- common.Message, errCh chan<- error) {
	var message common.Message
	for {
		if err := conn.ReadJSON(&message); err != nil {
			errCh <- err
			return
		}

		if err := validate.Validation(message); err != nil {
			errCh <- err
			return
		}

		if !*isProcessing {
			*isProcessing = true
			messageCh <- message
		} else {
			fmt.Println("dropped Message")
		}
	}
}

func queueToSynthFunc(ttsText synth.TtsText, synthFunc func(synth.TtsText) (synth.Audio, error)) (synth.Audio, error) {
	return synthFunc(ttsText)
}
