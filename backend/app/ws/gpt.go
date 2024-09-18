package ws

import (
	"app/database"
	"app/voicevox"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"regexp"
	"strconv"
	"sync"
	"time"

	openai "github.com/sashabaranov/go-openai"
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
			createDateAt, err := time.Parse(layout, time.Now().Format(layout))
			if err != nil {
				errCh <- err
				return
			}

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

func InitializeGPT(userId string, message Message) (*openai.ChatCompletionStream, error) {
	openaiToken, isExist := os.LookupEnv("OPENAI_TOKEN")
	if !isExist {
		return nil, errors.New("env variable OPENAI_TOKEN is not exist")
	}

	config := openai.DefaultConfig(openaiToken)
	config.BaseURL = openaiApiEndpoint
	client := openai.NewClientWithConfig(config)
	ctx := context.Background()

	chatCompletionMessages, err := newChatCompletionMessages(userId, message)
	if err != nil {
		return nil, err
	}

	req := openai.ChatCompletionRequest{
		Model:     openai.GPT4oMini,
		MaxTokens: maxTokensLength,
		Messages:  chatCompletionMessages,
		Stream:    true,
	}
	return client.CreateChatCompletionStream(ctx, req)
}

func patternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
}

func readLabel(fullText *string, stream *openai.ChatCompletionStream) (int, error) {
	//ラベル読み込み
	var matched []string
	for !patternChecked(labelPattern, *fullText) {
		response, err := stream.Recv()
		if err != nil {
			return errLabel, err
		}

		newToken := response.Choices[0].Delta.Content
		*fullText += newToken

		if len(*fullText) > labelMaxLength {
			return errLabel, errors.New(`model invalid`)
		}
	}

	matched = regexp.MustCompile(labelPattern).FindStringSubmatch(*fullText)

	//"[model="数字"]"のフォーマットに合うかどうか
	switch matched[1] {
	case "3", "1", "5", "22", "38", "76", "8":
		speakerId, err := strconv.Atoi(matched[1])
		if err != nil {
			return errLabel, err
		}
		return speakerId, nil

	default:
		return errLabel, errors.New(`speaker id invalid`)
	}
}
