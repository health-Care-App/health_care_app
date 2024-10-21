package chat

import (
	"app/common"
	"fmt"
	"regexp"
	"sort"
	"time"
)

func InitPrompt(userId string, model int, isSteam bool) (string, error) {
	defaultDate := time.Now().AddDate(0, 0, -systemWeekTerm).Format(common.Layout)
	ParsedOldDateAt, err := time.Parse(common.Layout, defaultDate)
	if err != nil {
		return "", err
	}

	healthData, err := common.GetHealthData(userId, ParsedOldDateAt)
	if err != nil {
		return "", err
	}

	sleepTimeData, err := common.GetSleepTimeData(userId, ParsedOldDateAt)
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
	var outputText string
	if model == 0 {
		characterText = zundamonnText
		if isSteam {
			outputText = zundamonStreamOutputText
		} else {
			outputText = zundamonOutputText
		}
	} else {
		characterText = tsumugiText
		if isSteam {
			outputText = tsumugiStreamOutputText
		} else {
			outputText = tsumugiOutputText
		}
	}

	return fmt.Sprintf(fullText, systemWeekTerm, healthText, sleepTimeText, characterText, outputText), nil
}

func RecvPromptMessage(userId string) (common.MessageGetResponse, error) {
	defaultDate := time.Now().AddDate(0, 0, -chatWeekTerm).Format(common.Layout)
	ParsedOldDateAt, err := time.Parse(common.Layout, defaultDate)
	if err != nil {
		return common.MessageGetResponse{}, err
	}

	response, err := common.GetMessageData(userId, ParsedOldDateAt)
	if err != nil {
		return common.MessageGetResponse{}, err
	}

	sort.Slice(response.Messages, func(i, j int) bool {
		return response.Messages[i].Date.Before(response.Messages[j].Date)
	})
	return response, nil
}

func PatternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
}
