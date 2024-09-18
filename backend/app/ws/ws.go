package ws

import (
	"app/database"
	"encoding/base64"
	"log"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

const (
	layout        = "2006-01-02"
	audioChLength = 10
	errChLength   = 1
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
	value, exists := c.Get("userId")
	if !exists {
		log.Println("invalid userId")
		return
	}
	userId := value.(string)

	audioBytes := make(chan []byte, audioChLength)
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

	//データベースに質問文を保存
	createDateAt, err := time.Parse(layout, time.Now().Format(layout))
	if err != nil {
		log.Println(err.Error())
		return
	}
	_, err = database.PostMessageData(
		userId,
		database.PostMessageDataQuery{
			Who:  "user",
			Text: message.Question,
			Date: createDateAt,
		})
	if err != nil {
		log.Println(err.Error())
		return
	}

	go CreateChatStream(message, audioBytes, errCh, &wg, userId)

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
