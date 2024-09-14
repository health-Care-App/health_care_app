package websocket

import (
	"app/gpt"
	b64 "encoding/base64"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func Wshandler(c *gin.Context) {
	audioBytes := make(chan []byte, 10)
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer conn.Close()

	_, message, err := conn.ReadMessage()
	if err != nil {
		log.Println(err)
		return
	}

	err = gpt.CreateChatStream(string(message), audioBytes)
	if err != nil {
		log.Println(err)
		return
	}

	for {
		bytes, ok := <-audioBytes
		if ok {
			base64Data := b64.StdEncoding.EncodeToString(bytes)
			conn.WriteMessage(websocket.TextMessage, []byte(base64Data))
		} else {
			break
		}
	}
}
