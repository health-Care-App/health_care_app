package ws

import (
	"app/gpt"
	"app/validate"
	"app/voicevox"
	"encoding/base64"
	"fmt"

	"github.com/gorilla/websocket"
)

func writeJson(audioStatus voicevox.Audio, conn *websocket.Conn, audioSendNumber *int) {
	base64Data := base64.StdEncoding.EncodeToString(audioStatus.Audiobytes)
	wsResponse := WsResponse{
		Base64Data: base64Data,
		Text:       audioStatus.Text,
	}
	conn.WriteJSON(wsResponse)
	*audioSendNumber++
}

func sendJson(audioStatus voicevox.Audio, audioBuffer *[]voicevox.Audio, audioSendNumber *int, conn *websocket.Conn) {
	fmt.Printf("audioStatus.Number: %d\n", audioStatus.Number)
	for len(*audioBuffer) > 0 {
		isPopped := false
		for i, bufferAudioStatus := range *audioBuffer {
			if *audioSendNumber == bufferAudioStatus.Number {
				writeJson(bufferAudioStatus, conn, audioSendNumber)
				*audioBuffer = append((*audioBuffer)[:i], (*audioBuffer)[i+1:]...)
				isPopped = true
				break
			}
		}
		if !isPopped {
			break
		}
	}

	if *audioSendNumber == audioStatus.Number {
		writeJson(audioStatus, conn, audioSendNumber)
	} else {
		*audioBuffer = append(*audioBuffer, audioStatus)
	}
}

func readJson(isProcessing *bool, conn *websocket.Conn, messageCh chan<- gpt.Message, errCh chan<- error) {
	var message gpt.Message
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
