package chat

import (
	"app/common"
	"app/database"
	"app/synth"
	"errors"
	"fmt"
	"io"
	"regexp"
	"strconv"
	"sync"
	"time"
)

func GptChatStream(message common.Message, ttsTextCh chan<- synth.TtsText, errCh chan<- error, doneCh chan<- bool, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""
	audioCounter := 0

	stream, err := InitGPT(userId, message)
	if err != nil {
		errCh <- err
		return
	}

	defer stream.Close()
	defer func() {
		doneCh <- true
	}()

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			wg.Wait()

			//データベースにGPTの回答を保存
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

		newToken := response.Choices[0].Delta.Content
		fullText += newToken
		buffer += newToken

		var matched []string
		if common.PatternChecked(common.LineTextPattern, buffer) {
			matched = regexp.MustCompile(common.LineTextPattern).FindStringSubmatch(buffer)
			recvText := matched[2]
			recvModel := matched[1]

			//フォーマットに合うかどうか
			switch recvModel {
			case "3", "1", "5", "22", "38", "76", "8":
				speakerId, err := strconv.Atoi(matched[1])
				if err != nil {
					errCh <- err
					return
				}

				if recvModel != matched[3] {
					errCh <- errors.New(`text line format invalid`)
					return
				}

				wg.Add(common.AddStep)
				fmt.Println(recvText)
				buffer = ""
				audioCounter++
				ttsTextCh <- synth.TtsText{
					Text:      recvText,
					SpeakerId: uint(speakerId),
				}

			default:
				errCh <- errors.New(`speaker id invalid`)
				return
			}
		}
	}
}
