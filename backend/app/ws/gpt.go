package ws

import (
	"app/database"
	"app/voicevox"
	"errors"
	"fmt"
	"io"
	"sync"
	"time"
)

func CreateChatStream(message Message, audioCh chan<- voicevox.Audio, errCh chan<- error, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""
	isPunctuationMatched := false
	audioCounter := 1

	defer close(audioCh)
	defer close(errCh)

	stream, err := InitializeGPT(userId, message)
	if err != nil {
		errCh <- err
		return
	}

	defer stream.Close()

	speakerId, err := readLabel(&fullText, stream)
	if err != nil {
		errCh <- err
		return
	}

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			if isPunctuationMatched {
				wg.Add(addStep)
				go voicevox.SpeechSynth(buffer, uint(speakerId), audioCh, errCh, wg, &audioCounter)
			}
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

		if isPunctuationMatched {
			//今ループが句読点にマッチしてないとき
			if !patternChecked(textEndPattern, newToken) {
				isPunctuationMatched = false

				fmt.Println(buffer)
				//音声合成処理処理
				wg.Add(addStep)
				go voicevox.SpeechSynth(buffer, uint(speakerId), audioCh, errCh, wg, &audioCounter)
				buffer = newToken

				//今ループが句読点のとき
			} else {
				buffer += newToken
			}
			//今ループで句読点にマッチしたとき
		} else if patternChecked(textEndPattern, newToken) {
			isPunctuationMatched = true
			buffer += newToken
		} else {
			buffer += newToken
		}
	}
}
