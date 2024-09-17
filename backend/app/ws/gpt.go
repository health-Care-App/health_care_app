package ws

import (
	"app/voicevox"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"regexp"
	"strconv"
	"sync"

	openai "github.com/sashabaranov/go-openai"
)

const (
	openaiApiEndpoint = "https://api.openai.iniad.org/api/v1"
	maxTokensLength   = 100
)

func CreateChatStream(message Message, audioBytes chan<- []byte, errCh chan<- error, wg *sync.WaitGroup) {
	all := ""
	buffer := ""
	isPunctuationMatched := false
	var speakerId int

	defer close(audioBytes)
	defer close(errCh)

	stream, err := InitializeGPT(message)
	if err != nil {
		errCh <- err
		return
	}

	defer stream.Close()

	//ヘッダー読み込み
	var matched []string
	for !patternChecked(`^\[model=(\d+)\]`, all) {
		response, err := stream.Recv()
		if err != nil {
			errCh <- err
			return
		}

		newToken := response.Choices[0].Delta.Content
		all = fmt.Sprintf("%s%s", all, newToken)

		if len(all) > 10 {
			errCh <- errors.New(`model invalid`)
			return
		}
	}

	matched = regexp.MustCompile(`^\[model=(\d+)\]`).FindStringSubmatch(all)

	//"[model="数字"]"のフォーマットに合うかどうか
	if matched != nil {
		switch matched[1] {
		case "3", "1", "5", "22", "38", "76", "8":
			speakerId, err = strconv.Atoi(matched[1])
			if err != nil {
				errCh <- err
				return
			}

		default:
			errCh <- errors.New(`speaker id invalid`)
			return
		}
	}

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			if isPunctuationMatched {
				wg.Add(1)
				go voicevox.SpeechSynth(buffer, uint(speakerId), audioBytes, errCh, wg)
			}
			wg.Wait()
			return
		}

		if err != nil {
			errCh <- err
			return
		}

		newToken := response.Choices[0].Delta.Content
		all += newToken

		if isPunctuationMatched {
			//今ループが句読点にマッチしてないとき
			if !patternChecked(`[。\.!\?！？]$`, newToken) {
				isPunctuationMatched = false

				fmt.Println(buffer)
				//音声合成処理処理
				wg.Add(1)
				go voicevox.SpeechSynth(buffer, uint(speakerId), audioBytes, errCh, wg)
				buffer = newToken

				//今ループが句読点のとき
			} else {
				buffer = fmt.Sprintf("%s%s", buffer, newToken)
			}
			//今ループで句読点にマッチしたとき
		} else if patternChecked(`[。\.!\?！？]$`, newToken) {
			isPunctuationMatched = true
			buffer = fmt.Sprintf("%s%s", buffer, newToken)
		} else {
			buffer = fmt.Sprintf("%s%s", buffer, newToken)
		}
	}
}

func InitializeGPT(message Message) (*openai.ChatCompletionStream, error) {
	openaiToken, isExist := os.LookupEnv("OPENAI_TOKEN")
	if !isExist {
		return nil, errors.New("env variable OPENAI_TOKEN is not exist")
	}

	config := openai.DefaultConfig(openaiToken)
	config.BaseURL = openaiApiEndpoint
	client := openai.NewClientWithConfig(config)
	ctx := context.Background()

	req := openai.ChatCompletionRequest{
		Model:     openai.GPT4oMini,
		MaxTokens: maxTokensLength,
		Messages: []openai.ChatCompletionMessage{
			{
				Role:    openai.ChatMessageRoleSystem,
				Content: createSystemConf(message.Model),
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
