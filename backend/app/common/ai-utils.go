package common

import (
	"app/database"
	"fmt"
	"regexp"
	"sort"
	"time"
)

func InitPrompt(userId string, model int) (string, error) {
	defaultDate := time.Now().AddDate(0, 0, -systemWeekTerm).Format(Layout)
	ParsedOldDateAt, err := time.Parse(Layout, defaultDate)
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
			healthText += fmt.Sprintf("%s: %d\n", health.Date.Format(Layout), health.Health)
		}
	} else {
		healthText += "データなし"
	}

	sleepTimeText := ""
	if len(sleepTimeData.SleepTimes) > 0 {
		for _, sleepTime := range sleepTimeData.SleepTimes {
			sleepTimeText += fmt.Sprintf("%s: %d\n", sleepTime.Date.Format(Layout), sleepTime.SleepTime)
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

	return fmt.Sprintf(fullText, systemWeekTerm, healthText, sleepTimeText, characterText), nil
}

func RecvPromptMessage(userId string) (database.MessageGetResponse, error) {
	defaultDate := time.Now().AddDate(0, 0, -chatWeekTerm).Format(Layout)
	ParsedOldDateAt, err := time.Parse(Layout, defaultDate)
	if err != nil {
		return database.MessageGetResponse{}, err
	}

	response, err := database.GetMessageData(userId, ParsedOldDateAt)
	if err != nil {
		return database.MessageGetResponse{}, err
	}

	sort.Slice(response.Messages, func(i, j int) bool {
		return response.Messages[i].Date.Before(response.Messages[j].Date)
	})
	return response, nil
}

func PatternChecked(pattern string, checkText string) bool {
	return regexp.MustCompile(pattern).MatchString(checkText)
}
