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

func CreateChatStream(question string, audioBytes chan<- []byte) {
	var buffer string
	var wg sync.WaitGroup
	isPunctuationMatched := false

	stream, err := ConnectGPT(question)
	if err != nil {
		fmt.Printf("ChatCompletionStream error: %v\n", err)
		return
	}
	defer stream.Close()
	defer close(audioBytes)

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			if isPunctuationMatched {
				go voicevox.SpeechSynth(buffer, &wg, audioBytes)
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
		TextToAudioByte(&wg, &isPunctuationMatched, &buffer, newToken, audioBytes)
	}
}

func ConnectGPT(question string) (stream *openai.ChatCompletionStream, err error) {
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
				Content: question,
			},
		},
		Stream: true,
	}
	return client.CreateChatCompletionStream(ctx, req)
}

func patternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
}

func TextToAudioByte(wg *sync.WaitGroup, isPunctuationMatched *bool, buffer *string, newToken string, audioBytes chan<- []byte) {
	if *isPunctuationMatched {
		//今ループが句読点にマッチしてないとき
		if !patternChecked(`[。\.!\?！？]$`, newToken) {
			*isPunctuationMatched = false

			fmt.Println(*buffer)
			//音声合成処理処理
			go voicevox.SpeechSynth(*buffer, wg, audioBytes)
			wg.Add(1)
			*buffer = newToken

			//今ループが句読点のとき
		} else {
			*buffer = fmt.Sprintf("%s%s", *buffer, newToken)
		}
		//今ループで句読点にマッチしたとき
	} else if patternChecked(`[。\.!\?！？]$`, newToken) {
		*isPunctuationMatched = true
		*buffer = fmt.Sprintf("%s%s", *buffer, newToken)
	} else {
		*buffer = fmt.Sprintf("%s%s", *buffer, newToken)
	}
}
