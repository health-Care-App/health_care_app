package chat

import (
	"app/common"
	"context"
	"errors"
	"fmt"
	"os"

	"github.com/google/generative-ai-go/genai"
	"google.golang.org/api/option"
)

func InitGem() (*genai.Client, error) {
	gemToken, isExist := os.LookupEnv("GEM_TOKEN")
	if !isExist {
		return nil, errors.New("env variable GEM_TOKEN is not exist")
	}

	ctx := context.Background()
	client, err := genai.NewClient(ctx, option.WithAPIKey(gemToken))
	if err != nil {
		return nil, err
	}

	return client, nil
}

func initGemPrompt(userId string, message common.Message, client *genai.Client, isStream bool) (*genai.ChatSession, error) {
	//モデル設定
	model := client.GenerativeModel(gemModel)
	model.SetMaxOutputTokens(common.MaxTokensLength)
	model.SetTemperature(temp)

	//キャラの設定を生成
	prompt, err := common.InitPrompt(userId, message.Model, isStream)
	if err != nil {
		return nil, err
	}

	//キャラの設定をmodelに追加
	model.SystemInstruction = genai.NewUserContent(genai.Text(prompt))

	cs := model.StartChat()
	cs.History = []*genai.Content{}

	//会話履歴をとって来る
	response, err := common.RecvPromptMessage(userId)
	if err != nil {
		return nil, err
	}

	//会話履歴を追加
	for _, data := range response.Messages {
		cs.History = append(cs.History,
			&genai.Content{
				Parts: []genai.Part{
					genai.Text(data.Question),
				},
				Role: "user",
			},
			&genai.Content{
				Parts: []genai.Part{
					genai.Text(data.Answer),
				},
				Role: "model",
			},
		)
	}
	return cs, nil
}

func GemRequestStream(userId string, message common.Message, client *genai.Client) (*genai.GenerateContentResponseIterator, error) {
	defer client.Close()

	cs, err := initGemPrompt(userId, message, client, true)
	if err != nil {
		return nil, err
	}

	newQuestion := genai.Text(message.Question)
	return cs.SendMessageStream(context.Background(), newQuestion), nil
}

func GemRequest(userId string, message common.Message, client *genai.Client) (*genai.GenerateContentResponse, error) {
	defer client.Close()

	cs, err := initGemPrompt(userId, message, client, false)
	if err != nil {
		return nil, err
	}

	newQuestion := genai.Text(message.Question)
	return cs.SendMessage(context.Background(), newQuestion)
}

func recvGemResponse(resp *genai.GenerateContentResponse) string {
	text := ""
	for _, cand := range resp.Candidates {
		if cand.Content != nil {
			for _, part := range cand.Content.Parts {
				text += fmt.Sprintf("%v", part)
			}
		}
	}
	return text
}
