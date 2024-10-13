package gemini

import (
	"app/common"
	"context"
	"errors"
	"fmt"
	"os"

	"github.com/google/generative-ai-go/genai"
	"google.golang.org/api/option"
)

func InitGem(userId string, message common.Message) (*genai.GenerateContentResponseIterator, error) {
	gemToken, isExist := os.LookupEnv("GEM_TOKEN")
	if !isExist {
		return nil, errors.New("env variable GEM_TOKEN is not exist")
	}

	ctx := context.Background()
	client, err := genai.NewClient(ctx, option.WithAPIKey(gemToken))
	if err != nil {
		return nil, err
	}

	defer client.Close()

	//モデル設定
	model := client.GenerativeModel(gemModel)
	model.SetMaxOutputTokens(common.MaxTokensLength)
	model.SetTemperature(temp)

	cs := model.StartChat()
	cs.History = []*genai.Content{}

	response, err := common.RecvPromptMessage(userId)
	if err != nil {
		return nil, err
	}

	//会話履歴を生成
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

	//プロンプトを生成
	prompt, err := common.InitPrompt(userId, message.Model)
	if err != nil {
		return nil, err
	}

	//キャラの設定をプロンプトに追加
	model.SystemInstruction = genai.NewUserContent(genai.Text(prompt))

	newQuestion := genai.Text(message.Question)
	return cs.SendMessageStream(ctx, newQuestion), nil
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
