package gpt

import (
	"app/database"
	"app/voicevox"
	"errors"
	"fmt"
	"io"
	"regexp"
	"strconv"
	"sync"
	"time"
)

func CreateChatStream(message Message, audioCh chan<- voicevox.Audio, errCh chan<- error, doneCh chan<- bool, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""
	audioCounter := 0

	stream, err := InitializeGPT(userId, message)
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
		if patternChecked(lineTextPattern, buffer) {
			matched = regexp.MustCompile(lineTextPattern).FindStringSubmatch(buffer)

			//フォーマットに合うかどうか
			switch matched[1] {
			case "3", "1", "5", "22", "38", "76", "8":
				speakerId, err := strconv.Atoi(matched[1])
				if err != nil {
					errCh <- err
					return
				}

				if matched[1] != matched[3] {
					errCh <- errors.New(`text line format invalid`)
					return
				}

				wg.Add(addStep)
				fmt.Println(matched[2])
				buffer = ""
				audioCounter++
				go voicevox.SpeechSynth(matched[2], uint(speakerId), audioCh, errCh, wg, audioCounter)
				fmt.Printf("audioCounter: %d\n", audioCounter)

			default:
				errCh <- errors.New(`speaker id invalid`)
				return
			}
		}
	}
}
