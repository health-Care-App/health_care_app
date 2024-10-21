package chat

import (
	"app/common"
	"app/synth"
	"fmt"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"

	"google.golang.org/api/iterator"
)

func GemChatStream(message common.Message, ttsTextCh chan<- synth.TtsText, errCh chan<- error, doneCh chan<- bool, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""

	client, err := InitGem()
	if err != nil {
		errCh <- err
		return
	}

	stream, err := GemRequestStream(userId, message, client)
	if err != nil {
		errCh <- err
		return
	}

	defer func() {
		doneCh <- true
	}()

	for {
		response, err := stream.Next()
		if err == iterator.Done {
			wg.Wait()

			//データベースにGeminiの回答を保存
			createDateAt := time.Now()
			messagesDoc := common.MessagesDoc{
				Question: message.Question,
				Answer:   fullText,
				Date:     createDateAt,
			}
			_, err = common.PostMessageData(userId, messagesDoc)
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

		newToken := recvGemResponse(response)
		fullText += newToken
		buffer += newToken

		matched := regexp.MustCompile(common.LineTextPattern).FindAllStringSubmatch(buffer, -1)
		for _, data := range matched {
			recvText := data[2]
			recvModel := data[1]

			//フォーマットに合うかどうか
			switch recvModel {
			case "3", "1", "5", "22", "38", "76", "8":
				speakerId, err := strconv.Atoi(recvModel)
				if err != nil {
					errCh <- err
					return
				}

				if recvModel != data[3] {
					errCh <- errGeminiTagMissMatch
					return
				}

				wg.Add(common.AddStep)
				fmt.Println(recvText)
				ttsTextCh <- synth.TtsText{
					Text:      recvText,
					SpeakerId: uint(speakerId),
				}

			default:
				errCh <- errGeminiSpeakerId
				return
			}

			//マッチした文章をバッファから削除
			rep := strings.NewReplacer(data[0], "")
			buffer = rep.Replace(buffer)
		}
	}
}

func GeminiChatApi(message common.Message, userId string) (synth.TtsText, error) {
	client, err := InitGem()
	if err != nil {
		return synth.TtsText{}, err
	}

	resp, err := GemRequest(userId, message, client)
	if err != nil {
		return synth.TtsText{}, err
	}

	// フォーマットチェック
	respText := recvGemResponse(resp)
	if !common.PatternChecked(common.LineTextPattern, respText) {
		return synth.TtsText{}, errGeminiTextMissMatch
	}

	matched := regexp.MustCompile(common.LineTextPattern).FindStringSubmatch(respText)
	recvText := matched[2]
	recvModel := matched[1]

	// フォーマットに合うかどうか
	switch recvModel {
	case "3", "1", "5", "22", "38", "76", "8":
		speakerId, err := strconv.Atoi(matched[1])
		if err != nil {
			return synth.TtsText{}, err
		}

		//フォーマットチェック
		if recvModel != matched[3] {
			return synth.TtsText{}, errGeminiTagMissMatch
		}

		fmt.Println(recvText)
		return synth.TtsText{
			Text:      recvText,
			SpeakerId: uint(speakerId),
		}, nil

	default:
		return synth.TtsText{}, errGeminiSpeakerId
	}
}
