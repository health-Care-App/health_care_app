package ws

import (
	"app/common"
	"app/validate"
	"app/voicevox"
	"encoding/base64"
	"log"
	"sync"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func Wshandler(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Println(err)
		return
	}

	defer conn.Close()

	var message Message
	err = conn.ReadJSON(&message)
	if err != nil {
		log.Println(err)
		return
	}

	if err := validate.Validation(message); err != nil {
		log.Println(err)
		return
	}

	var wg sync.WaitGroup
	audioCh := make(chan voicevox.Audio, audioChLength)
	errCh := make(chan error, errChLength)
	userId := common.NewUserId(c)
	go CreateChatStream(message, audioCh, errCh, &wg, userId)

	var audioArray []voicevox.Audio
	audioSendCounter := 1
	for {
		audioStatus, ok := <-audioCh

		for len(audioArray) > 0 {
			for _, audioStatusBuffer := range audioArray {
				if audioSendCounter == audioStatusBuffer.Number {
					writeBase64(audioStatusBuffer.Audiobytes, conn, &audioSendCounter)
					break
				}
			}
			break
		}
		if ok {
			if audioSendCounter == audioStatus.Number {
				writeBase64(audioStatus.Audiobytes, conn, &audioSendCounter)
			} else {
				audioArray = append(audioArray, audioStatus)
			}
		} else {
			break
		}
	}

	if err, ok := <-errCh; ok {
		log.Println(err)
	}
}

func writeBase64(audioBytes []byte, conn *websocket.Conn, audioSendCounter *int) {
	base64Data := base64.StdEncoding.EncodeToString(audioBytes)
	conn.WriteMessage(websocket.TextMessage, []byte(base64Data))
	*audioSendCounter++
}
