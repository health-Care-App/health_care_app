package ws

import (
	"app/common"
	"app/validate"
	"app/voicevox"
	"encoding/base64"
	"fmt"
	"sync"

	"github.com/gorilla/websocket"
)

func writeJson(audio voicevox.Audio, conn *websocket.Conn, errCh chan<- error) {
	base64Data := base64.StdEncoding.EncodeToString(audio.Audiobytes)
	wsResponse := WsResponse{
		Base64Data: base64Data,
		Text:       audio.Text,
		SpeakerId:  audio.SpeakerId,
	}

	if err := validate.Validation(wsResponse); err != nil {
		errCh <- err
		return
	}

	conn.WriteJSON(wsResponse)
}

func sendJson(ttsTextCh <-chan voicevox.TtsWaitText, conn *websocket.Conn, wg *sync.WaitGroup, errCh chan<- error) {
	for {
		ttsText := <-ttsTextCh
		audio, err := queueToSynthFunc(ttsText, voicevox.SpeechSynth)
		if err != nil {
			errCh <- err
			return
		}
		writeJson(audio, conn, errCh)
		wg.Done()
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

func queueToSynthFunc(ttsText voicevox.TtsWaitText, synthFunc func(string, uint) (voicevox.Audio, error)) (voicevox.Audio, error) {
	return synthFunc(ttsText.Text, ttsText.SpeakerId)
}
