package chat

import (
	"app/common"
	"context"
	"errors"
	"os"

	openai "github.com/sashabaranov/go-openai"
)

func InitGptPrompt(userId string, message common.Message, isStream bool) ([]openai.ChatCompletionMessage, error) {
	var chatCompletionMessges []openai.ChatCompletionMessage

	response, err := common.RecvPromptMessage(userId)
	if err != nil {
		return []openai.ChatCompletionMessage{}, err
	}

	for _, data := range response.Messages {
		chatCompletionMessges = append(chatCompletionMessges,
			openai.ChatCompletionMessage{
				Role:    openai.ChatMessageRoleUser,
				Content: data.Question,
			},
			openai.ChatCompletionMessage{
				Role:    openai.ChatMessageRoleAssistant,
				Content: data.Answer,
			},
		)
	}

	prompt, err := common.InitPrompt(userId, message.Model, isStream)
	if err != nil {
		return []openai.ChatCompletionMessage{}, err
	}

	chatCompletionMessges = append(chatCompletionMessges,
		openai.ChatCompletionMessage{
			Role:    openai.ChatMessageRoleSystem,
			Content: prompt,
		},
		openai.ChatCompletionMessage{
			Role:    openai.ChatMessageRoleUser,
			Content: message.Question,
		},
	)
	return chatCompletionMessges, nil
}

func InitGPT() (*openai.Client, error) {
	openaiToken, isExist := os.LookupEnv("OPENAI_TOKEN")
	if !isExist {
		return nil, errors.New("env variable OPENAI_TOKEN is not exist")
	}

	config := openai.DefaultConfig(openaiToken)
	config.BaseURL = openaiApiEndpoint
	client := openai.NewClientWithConfig(config)
	return client, nil
}

func GPTRequest(userId string, message common.Message, client *openai.Client) (openai.ChatCompletionResponse, error) {
	chatCompletionMessages, err := InitGptPrompt(userId, message, false)
	if err != nil {
		return openai.ChatCompletionResponse{}, err
	}

	req := openai.ChatCompletionRequest{
		Model:     openai.GPT4oMini,
		MaxTokens: common.MaxTokensLength,
		Messages:  chatCompletionMessages,
	}

	return client.CreateChatCompletion(context.Background(), req)
}

func GPTRequestStream(userId string, message common.Message, client *openai.Client) (*openai.ChatCompletionStream, error) {
	chatCompletionMessages, err := InitGptPrompt(userId, message, true)
	if err != nil {
		return &openai.ChatCompletionStream{}, err
	}

	req := openai.ChatCompletionRequest{
		Model:     openai.GPT4oMini,
		MaxTokens: common.MaxTokensLength,
		Messages:  chatCompletionMessages,
		Stream: true,
	}

	return client.CreateChatCompletionStream(context.Background(), req)
}
