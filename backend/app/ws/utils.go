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

func writeJson(audio synth.Audio, conn *websocket.Conn, errCh chan<- error) {
	base64Data := base64.StdEncoding.EncodeToString(audio.Audiobytes)
	wsResponse := common.WsResponse{
		Base64Data: base64Data,
		Text:       audio.TtsText.Text,
		SpeakerId:  audio.TtsText.SpeakerId,
	}

	if err := validate.Validation(wsResponse); err != nil {
		errCh <- err
		return
	}

	conn.WriteJSON(wsResponse)
}

func sendJson(ttsTextCh <-chan synth.TtsText, conn *websocket.Conn, wg *sync.WaitGroup, errCh chan<- error) {
	for {
		ttsText := <-ttsTextCh

		audio, err := queueToSynthFunc(ttsText, synth.VoiceVoxApiSynth)
		wg.Done()

		if err != nil {
			errCh <- err
			return
		}
		writeJson(audio, conn, errCh)
	}
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
