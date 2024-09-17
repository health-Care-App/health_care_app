package ws

import (
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

type Message struct {
	Question string `json:"question" validate:"required"`
	//ずんだもんの場合0, 春日部つむぎの場合1
	Model uint `json:"model" validate:"required,oneof=0 1"`
}

func Wshandler(c *gin.Context) {
	audioBytes := make(chan []byte, 10)
	errCh := make(chan error, 10)
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

	go CreateChatStream(message, audioBytes, errCh, &wg)

	for {
		bytes, ok := <-audioBytes
		if ok {
			base64Data := base64.StdEncoding.EncodeToString(bytes)
			conn.WriteMessage(websocket.TextMessage, []byte(base64Data))
		} else {
			break
		}
	}

	if err, ok := <-errCh; ok {
		log.Println(err)
	}

	defer conn.Close()
}
