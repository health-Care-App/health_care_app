package ws

import (
	"app/common"
	"app/synth"
	"app/validate"
	"fmt"
	"sync"

	"github.com/gorilla/websocket"
)

func sendJson(isSynth bool, ttsText synth.TtsText, wg *sync.WaitGroup, conn *websocket.Conn, errCh chan<- error) {
	base64Data, err := synth.TextToBase64(isSynth, ttsText)
	if err != nil {
		errCh <- err
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
