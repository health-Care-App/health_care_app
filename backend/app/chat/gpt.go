package chat

import (
	"app/common"
	"app/synth"
	"errors"
	"fmt"
	"io"
	"regexp"
	"strconv"
	"sync"
	"time"
)

func GptChatStream(message common.Message, ttsTextCh chan<- synth.TtsText, errCh chan<- error, doneCh chan<- bool, wg *sync.WaitGroup, userId string) {
	fullText := ""
	buffer := ""

	client, err := InitGPT()
	if err != nil {
		errCh <- err
		return
	}

	stream, err := GPTRequestStream(userId, message, client)
	if err != nil {
		errCh <- err
		return
	}

	defer stream.Close()
	defer func() {
		doneCh <- true
	}()

	for {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			wg.Wait()

			//データベースにGPTの回答を保存
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

		newToken := response.Choices[0].Delta.Content
		fullText += newToken
		buffer += newToken

		if PatternChecked(common.LineTextPattern, buffer) {
			matched := regexp.MustCompile(common.LineTextPattern).FindStringSubmatch(buffer)
			recvText := matched[2]
			recvModel := matched[1]

			//フォーマットに合うかどうか
			switch recvModel {
			case "3", "1", "5", "22", "38", "76", "8":
				speakerId, err := strconv.Atoi(matched[1])
				if err != nil {
					errCh <- err
					return
				}

				if recvModel != matched[3] {
					errCh <- errGptTagMissMatch
					return
				}

				wg.Add(common.AddStep)
				fmt.Println(recvText)
				buffer = ""
				ttsTextCh <- synth.TtsText{
					Text:      recvText,
					SpeakerId: uint(speakerId),
				}

			default:
				errCh <- errGptSpeakerId
				return
			}
		}
	}
}

func GptChatApi(message common.Message, userId string) (synth.TtsText, error) {
	client, err := InitGPT()
	if err != nil {
		return synth.TtsText{}, err
	}

	resp, err := GPTRequest(userId, message, client)
	if err != nil {
		return synth.TtsText{}, err
	}

	//フォーマットチェック
	respText := resp.Choices[0].Message.Content
	if !PatternChecked(common.LineTextPattern, respText) {
		return synth.TtsText{}, errGptTextMissMatch
	}

	matched := regexp.MustCompile(common.LineTextPattern).FindStringSubmatch(respText)
	recvText := matched[2]
	recvModel := matched[1]

	//フォーマットに合うかどうか
	switch recvModel {
	case "3", "1", "5", "22", "38", "76", "8":
		speakerId, err := strconv.Atoi(matched[1])
		if err != nil {
			return synth.TtsText{}, err
		}

		//フォーマットチェック
		if recvModel != matched[3] {
			return synth.TtsText{}, err
		}

		fmt.Println(recvText)
		return synth.TtsText{
			Text:      recvText,
			SpeakerId: uint(speakerId),
		}, nil

	default:
		return synth.TtsText{}, errGptSpeakerId
	}
}
