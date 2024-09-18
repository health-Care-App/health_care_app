package ws

import (
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
	value, exists := c.Get("userId")
	if !exists {
		log.Println("invalid userId")
		return
	}
	userId := value.(string)

	audioCh := make(chan voicevox.Audio, audioChLength)
	errCh := make(chan error, errChLength)
	var wg sync.WaitGroup
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Println(err)
		return
	}

	var message Message
	err = conn.ReadJSON(&message)
	if err != nil {
		log.Println(err)
		return
	}

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

	defer conn.Close()
}

func writeBase64(audioBytes []byte, conn *websocket.Conn, audioSendCounter *int) {
	base64Data := base64.StdEncoding.EncodeToString(audioBytes)
	conn.WriteMessage(websocket.TextMessage, []byte(base64Data))
	*audioSendCounter++
}
