package ws

import (
	"app/common"
	"app/gpt"
	"app/voicevox"
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

	messageCh := make(chan gpt.Message, messageChLength)
	audioCh := make(chan voicevox.Audio, audioChLength)
	errCh := make(chan error, errChLength)
	doneCh := make(chan bool, doneChLength)
	defer close(messageCh)
	defer close(audioCh)
	defer close(errCh)
	defer close(doneCh)

	userId := common.NewUserId(c)
	var wg sync.WaitGroup
	audioSendNumber := 1
	isProcessing := false
	var audioBuffer []voicevox.Audio

	go readJson(&isProcessing, conn, messageCh, errCh)
	for {
		select {
		case message, ok := <-messageCh:
			if ok {
				go gpt.CreateChatStream(message, audioCh, errCh, doneCh, &wg, userId)
			}
		case audioStatus, ok := <-audioCh:
			if ok {
				sendJson(audioStatus, &audioBuffer, &audioSendNumber, conn, errCh)
			}
		case done, ok := <-doneCh:
			if done && ok {
				audioSendNumber = 1
				isProcessing = false
				audioBuffer = []voicevox.Audio{}
			}
		case err, notOk := <-errCh:
			if notOk {
				log.Println(err)
				return
			}
		}
	}
}
