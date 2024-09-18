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

const (
	openaiApiEndpoint = "https://api.openai.iniad.org/api/v1"
	labelPattern      = `^\[model=(\d+)\]`
	textEndPattern    = `[。\.!\?！？]$`
	maxTokensLength   = 100
	labelMaxLength    = 10
	addStep           = 1
	errLabel          = -1
)

func CreateChatStream(message Message, audioBytes chan<- []byte, errCh chan<- error, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""
	isPunctuationMatched := false

	defer close(audioBytes)
	defer close(errCh)

	stream, err := InitializeGPT(userId, message)
	if err != nil {
		errCh <- err
		return
	}

	defer stream.Close()

	speakerId, err := readLabel(fullText, stream)
	if err != nil {
		errCh <- err
		return
	}

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			if isPunctuationMatched {
				wg.Add(addStep)
				go voicevox.SpeechSynth(buffer, uint(speakerId), audioBytes, errCh, wg)
			}
			wg.Wait()

			//データベースにGPTの回答を保存
			createDateAt, err := time.Parse(layout, time.Now().Format(layout))
			if err != nil {
				errCh <- err
				return
			}
			_, err = database.PostMessageData(
				userId,
				database.PostMessageDataQuery{
					Who:  "system",
					Text: fullText,
					Date: createDateAt,
				})
			if err != nil {
				errCh <- err
				return
			}

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
				go voicevox.SpeechSynth(buffer, uint(speakerId), audioBytes, errCh, wg)
				buffer = newToken

				//今ループが句読点のとき
			} else {
				buffer = fmt.Sprintf("%s%s", buffer, newToken)
			}
			//今ループで句読点にマッチしたとき
		} else if patternChecked(textEndPattern, newToken) {
			isPunctuationMatched = true
			buffer = fmt.Sprintf("%s%s", buffer, newToken)
		} else {
			buffer = fmt.Sprintf("%s%s", buffer, newToken)
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
	systemConf, err := createSystemConf(userId, message.Model)
	if err != nil {
		return nil, err
	}

	req := openai.ChatCompletionRequest{
		Model:     openai.GPT4oMini,
		MaxTokens: maxTokensLength,
		Messages: []openai.ChatCompletionMessage{
			{
				Role:    openai.ChatMessageRoleSystem,
				Content: systemConf,
			},
			{
				Role:    openai.ChatMessageRoleUser,
				Content: message.Question,
			},
		},
		Stream: true,
	}
	return client.CreateChatCompletionStream(ctx, req)
}

func patternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
}

func readLabel(fullText string, stream *openai.ChatCompletionStream) (int, error) {
	//ラベル読み込み
	var matched []string
	for !patternChecked(labelPattern, fullText) {
		response, err := stream.Recv()
		if err != nil {
			return errLabel, err
		}

		newToken := response.Choices[0].Delta.Content
		fullText = fmt.Sprintf("%s%s", fullText, newToken)

		if len(fullText) > labelMaxLength {
			return errLabel, errors.New(`model invalid`)
		}
	}

	matched = regexp.MustCompile(labelPattern).FindStringSubmatch(fullText)

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
