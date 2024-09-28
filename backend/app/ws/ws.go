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

	isProcessing := false
	messageCh := make(chan gpt.Message, 1)
	userId := common.NewUserId(c)
	errCh := make(chan error, errChLength)

	go readJson(&isProcessing, conn, messageCh, errCh)
	for {
		select {
		case message := <-messageCh:
			var wg sync.WaitGroup
			audioCh := make(chan voicevox.Audio, audioChLength)

			go gpt.CreateChatStream(message, audioCh, errCh, &wg, userId)
			go encodeBase64(audioCh, conn, &isProcessing)
		case err, notOk := <-errCh:
			if notOk {
				log.Println(err)
				return
			}
		}
	}
}
