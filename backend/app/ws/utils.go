package ws

import (
	"app/common"
	"app/validate"
	"app/voicevox"
	"encoding/base64"
	"fmt"

	"github.com/gorilla/websocket"
)

func writeJson(audioStatus voicevox.Audio, conn *websocket.Conn, audioSendNumber *int, errCh chan<- error) {
	base64Data := base64.StdEncoding.EncodeToString(audioStatus.Audiobytes)
	wsResponse := WsResponse{
		Base64Data: base64Data,
		Text:       audioStatus.Text,
	}

	if err := validate.Validation(wsResponse); err != nil {
		errCh <- err
		return
	}

	conn.WriteJSON(wsResponse)
	*audioSendNumber++
}

func getAudioFromBuf(audioBuffer *[]voicevox.Audio, audioSendNumber *int, conn *websocket.Conn, errCh chan<- error) {
	for len(*audioBuffer) > 0 {
		isPopped := false
		for i, bufferAudioStatus := range *audioBuffer {
			if *audioSendNumber == bufferAudioStatus.Number {
				writeJson(bufferAudioStatus, conn, audioSendNumber, errCh)
				*audioBuffer = append((*audioBuffer)[:i], (*audioBuffer)[i+1:]...)
				isPopped = true
				break
			}
		}
		if !isPopped {
			break
		}
	}
}

func sendJson(audioStatus voicevox.Audio, audioBuffer *[]voicevox.Audio, audioSendNumber *int, conn *websocket.Conn, errCh chan<- error) {
	fmt.Printf("audioStatus.Number: %d\n", audioStatus.Number)

	//bufferに残ったaudioを処理
	getAudioFromBuf(audioBuffer, audioSendNumber, conn, errCh)

	if *audioSendNumber == audioStatus.Number {
		writeJson(audioStatus, conn, audioSendNumber, errCh)
	} else {
		*audioBuffer = append(*audioBuffer, audioStatus)
	}

	//bufferに残ったaudioを処理
	getAudioFromBuf(audioBuffer, audioSendNumber, conn, errCh)
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
