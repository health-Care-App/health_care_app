package ws

import (
	"app/chat"
	"app/common"
	"app/synth"
	"app/validate"
	"fmt"
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

	messageCh := make(chan common.Message, messageChLength)
	ttsTextCh := make(chan synth.TtsText, ttsTextChLength)
	errCh := make(chan error, errChLength)
	doneCh := make(chan bool, doneChLength)
	defer close(messageCh)
	defer close(ttsTextCh)
	defer close(errCh)
	defer close(doneCh)

	userId := common.NewUserId(c)
	var wg sync.WaitGroup
	var isSynth bool
	isProcessing := false

	go readJson(&isProcessing, conn, messageCh, errCh)
	for {
		select {
		case message, ok := <-messageCh:
			if ok {
				isSynth = message.IsSynth
				if message.ChatModel == 0 {
					//Gptで会話
					fmt.Println("Gpt called")
					go chat.GptChatStream(message, ttsTextCh, errCh, doneCh, &wg, userId)
				} else {
					//Geminiで会話
					fmt.Println("Gemini called")
					go chat.GemChatStream(message, ttsTextCh, errCh, doneCh, &wg, userId)
				}
			}

		case ttsText, ok := <-ttsTextCh:
			if ok {
				sendJson(isSynth, ttsText, &wg, conn, errCh)
			}

		case done, ok := <-doneCh:
			if done && ok {
				isProcessing = false

				//送信終了を知らせる空データ
				wsResponse := common.WsResponse{
					Base64Data: "",
					Text:       "",
					SpeakerId:  0,
				}
				if err := validate.Validation(wsResponse); err != nil {
					log.Println(err)
					return
				}
				conn.WriteJSON(wsResponse)
			}

		case err, notOk := <-errCh:
			if notOk {
				log.Println(err)
				return
			}
		}
	}
}
