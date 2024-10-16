package gemini

import (
	"app/common"
	"app/database"
	"app/voicevox"
	"errors"
	"fmt"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"

	"google.golang.org/api/iterator"
)

func GemChatStream(message common.Message, ttsTextCh chan<- voicevox.TtsWaitText, errCh chan<- error, doneCh chan<- bool, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""

	stream, err := InitGem(userId, message)
	if err != nil {
		errCh <- err
		return
	}

	defer func() {
		doneCh <- true
	}()

	for {
		response, err := stream.Next()
		if err == iterator.Done {
			wg.Wait()

			//データベースにGeminiの回答を保存
			createDateAt := time.Now()
			messagesDoc := database.MessagesDoc{
				Question: message.Question,
				Answer:   fullText,
				Date:     createDateAt,
			}
			_, err = database.PostMessageData(userId, messagesDoc)
			if err != nil {
				errCh <- err
				return
			}

			//正常終了
			fmt.Println("successful completion")
			return
		}

		if err != nil {
			errCh <- err
			return
		}

		newToken := recvGemResponse(response)
		fullText += newToken
		buffer += newToken

		matched := regexp.MustCompile(common.LineTextPattern).FindAllStringSubmatch(buffer, -1)
		for _, data := range matched {
			recvText := data[2]
			recvModel := data[1]

			//フォーマットに合うかどうか
			switch recvModel {
			case "3", "1", "5", "22", "38", "76", "8":
				speakerId, err := strconv.Atoi(recvModel)
				if err != nil {
					errCh <- err
					return
				}

				if recvModel != data[3] {
					errCh <- errors.New(`text line format invalid`)
					return
				}

				wg.Add(common.AddStep)
				fmt.Println(recvText)
				ttsTextCh <- voicevox.TtsWaitText{
					Text:      recvText,
					SpeakerId: uint(speakerId),
				}

			default:
				errCh <- errors.New(`speaker id invalid`)
				return
			}

			//マッチした文章をバッファから削除
			rep := strings.NewReplacer(data[0], "")
			buffer = rep.Replace(buffer)
		}
	}
}
