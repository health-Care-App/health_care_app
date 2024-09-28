package ws

import (
	"app/gpt"
	"app/validate"
	"app/voicevox"
	"encoding/base64"
	"fmt"

	"github.com/gorilla/websocket"
)

func writeJson(audioStatus voicevox.Audio, conn *websocket.Conn, audioSendCounter *int) {
	base64Data := base64.StdEncoding.EncodeToString(audioStatus.Audiobytes)
	wsResponse := WsResponse{
		Base64Data: base64Data,
		Text:       audioStatus.Text,
	}
	conn.WriteJSON(wsResponse)
	*audioSendCounter++
}

func encodeBase64(audioCh <-chan voicevox.Audio, conn *websocket.Conn, isProcessing *bool) {
	var audioBuffer []voicevox.Audio
	audioSendCounter := 1
	for {
		audioStatus, ok := <-audioCh

		fmt.Printf("audioStatus.Number: %d\n", audioStatus.Number)
		for len(audioBuffer) > 0 {
			isPopped := false
			for i, bufferAudioStatus := range audioBuffer {
				if audioSendCounter == bufferAudioStatus.Number {
					writeJson(bufferAudioStatus, conn, &audioSendCounter)
					audioBuffer = append(audioBuffer[:i], audioBuffer[i+1:]...)
					isPopped = true
					break
				}
			}
			if !isPopped {
				break
			}
		}

		if ok {
			if audioSendCounter == audioStatus.Number {
				writeJson(audioStatus, conn, &audioSendCounter)
			} else {
				audioBuffer = append(audioBuffer, audioStatus)
			}
		} else {
			break
		}
	}
	*isProcessing = false
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
		}
	}
}
