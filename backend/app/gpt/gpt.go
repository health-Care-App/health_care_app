package gpt

import (
	"app/voicevox"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"regexp"

	openai "github.com/sashabaranov/go-openai"
)

const (
	openaiApiEndpoint = "https://api.openai.iniad.org/api/v1"
	maxTokensLength   = 50
)

func CreateChatStream(question string, audioBytes chan<- []byte) error {
	var errChan = make(chan error)
	buffer := ""
	audioNum := 0
	isPunctuationMatched := false

	stream, err := InitializeGPT(question)
	if err != nil {
		return err
	}

	defer stream.Close()
	defer close(audioBytes)

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			if isPunctuationMatched {
				go voicevox.SpeechSynth(buffer, audioBytes, errChan)
				audioNum++
			}

			for i := 0; i < audioNum; i++ {
				if err := <-errChan; err != nil {
					return err
				}
			}

			return nil
		}

		if err != nil {
			return err
		}

		newToken := response.Choices[0].Delta.Content
		TextToAudioByte(&audioNum, &isPunctuationMatched, &buffer, newToken, audioBytes, errChan)
	}

}

func InitializeGPT(question string) (*openai.ChatCompletionStream, error) {
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

func TextToAudioByte(audioNum *int, isPunctuationMatched *bool, buffer *string, newToken string, audioBytes chan<- []byte, errChan chan<- error) {
	if *isPunctuationMatched {
		//今ループが句読点にマッチしてないとき
		if !patternChecked(`[。\.!\?！？]$`, newToken) {
			*isPunctuationMatched = false

			fmt.Println(*buffer)
			//音声合成処理処理
			go voicevox.SpeechSynth(*buffer, audioBytes, errChan)
			*audioNum++
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
