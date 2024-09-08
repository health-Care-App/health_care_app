package gpt

import (
	"app/voicevox"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"regexp"
	"sync"

	openai "github.com/sashabaranov/go-openai"
)

const (
	openaiApiEndpoint = "https://api.openai.iniad.org/api/v1"
	maxTokensLength   = 50
)

func CreateChatStream(query string) {
	var buffer string
	var wg sync.WaitGroup
	isPunctuationMatched := false

	openaiToken, isExist := os.LookupEnv("OPENAI_TOKEN")
	if !isExist {
		fmt.Println("OPENAI_TOKEN should be setted")
		return
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
				Role:    openai.ChatMessageRoleUser,
				Content: query,
			},
		},
		Stream: true,
	}
	stream, err := client.CreateChatCompletionStream(ctx, req)
	if err != nil {
		fmt.Printf("ChatCompletionStream error: %v\n", err)
		return
	}
	defer stream.Close()

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			if isPunctuationMatched {
				go voicevox.SpeechSynth(buffer, &wg)
				wg.Add(1)
			}
			wg.Wait()
			return
		}

		if err != nil {
			fmt.Printf("\nStream error: %v\n", err)
			return
		}

		newToken := response.Choices[0].Delta.Content

		//前ループが句読点にマッチしたとき
		if isPunctuationMatched {
			fmt.Println("before loop matched")
			//今ループが句読点にマッチしてないとき
			if !patternChecked(`[。\.!\?！？]$`, newToken) {
				isPunctuationMatched = false

				fmt.Println(buffer)
				//音声合成処理にパスする処理
				go voicevox.SpeechSynth(buffer, &wg)
				wg.Add(1)
				buffer = newToken

				//今ループが句読点のとき
			} else {
				buffer = fmt.Sprintf("%s%s", buffer, newToken)
			}
			//今ループで句読点にマッチしたとき
		} else if patternChecked(`[。\.!\?！？]$`, newToken) {
			fmt.Println("now loop pattern matched")
			isPunctuationMatched = true
			buffer = fmt.Sprintf("%s%s", buffer, newToken)
		} else {
			buffer = fmt.Sprintf("%s%s", buffer, newToken)
		}
	}
}

func patternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
}
