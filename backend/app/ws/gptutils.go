package ws

import (
	"app/common"
	"app/database"
	"context"
	"errors"
	"fmt"
	"os"
	"regexp"
	"sort"
	"time"

	openai "github.com/sashabaranov/go-openai"
)

func createSystemConf(userId string, model int) (string, error) {
	defaultDate := time.Now().AddDate(0, 0, -systemWeekTerm).Format(common.Layout)
	ParsedOldDateAt, err := time.Parse(common.Layout, defaultDate)
	if err != nil {
		return "", err
	}

	healthData, err := database.GetHealthData(userId, ParsedOldDateAt)
	if err != nil {
		return "", err
	}

	sleepTimeData, err := database.GetSleepTimeData(userId, ParsedOldDateAt)
	if err != nil {
		return "", err
	}

	healthText := ""
	if len(healthData.Healths) > 0 {
		for _, health := range healthData.Healths {
			healthText += fmt.Sprintf("%s: %d\n", health.Date.Format(common.Layout), health.Health)
		}
	} else {
		healthText += "データなし"
	}

	sleepTimeText := ""
	if len(sleepTimeData.SleepTimes) > 0 {
		for _, sleepTime := range sleepTimeData.SleepTimes {
			sleepTimeText += fmt.Sprintf("%s: %d\n", sleepTime.Date.Format(common.Layout), sleepTime.SleepTime)
		}
	} else {
		sleepTimeText += "データなし"
	}

	var characterText string
	if model == 0 {
		characterText = zundamonnText
	} else {
		characterText = tsumugiText
	}

	return fmt.Sprintf(fullText, characterText, systemWeekTerm, healthText, sleepTimeText), nil
}

func newChatCompletionMessages(userId string, message Message) ([]openai.ChatCompletionMessage, error) {
	var chatCompletionMessges []openai.ChatCompletionMessage
	defaultDate := time.Now().AddDate(0, 0, -chatWeekTerm).Format(common.Layout)
	ParsedOldDateAt, err := time.Parse(common.Layout, defaultDate)
	if err != nil {
		return []openai.ChatCompletionMessage{}, err
	}

	response, err := database.GetMessageData(userId, ParsedOldDateAt)
	if err != nil {
		return []openai.ChatCompletionMessage{}, err
	}

	sort.Slice(response.Messages, func(i, j int) bool {
		return response.Messages[i].Date.Before(response.Messages[j].Date)
	})

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

	systemConf, err := createSystemConf(userId, message.Model)
	if err != nil {
		return []openai.ChatCompletionMessage{}, err
	}

	chatCompletionMessges = append(chatCompletionMessges,
		openai.ChatCompletionMessage{
			Role:    openai.ChatMessageRoleSystem,
			Content: systemConf,
		},
		openai.ChatCompletionMessage{
			Role:    openai.ChatMessageRoleUser,
			Content: message.Question,
		},
	)
	return chatCompletionMessges, nil
}

func patternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
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
