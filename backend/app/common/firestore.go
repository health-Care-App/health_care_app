package common

import (
	"app/firebaseinit"
	"context"
	"time"

	"google.golang.org/api/iterator"
)

const (
	healthCollec       = "health"
	healthSubCollec    = "healths"
	sleepTimeCollec    = "sleepTime"
	sleepTimeSubCollec = "sleepTimes"
	messageCollec      = "message"
	messageSubCollec   = "messages"

	statusOk = "ok"
)

// データベースから健康状態のデータを取得する関数
func GetHealthData(userId string, oldDateAt time.Time) (HealthGetResponse, error) {
	client, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return HealthGetResponse{}, err
	}
	defer client.Close()

	query := client.Collection(healthCollec).Doc(userId).Collection(healthSubCollec)
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(context.Background())
	var healths []Healths
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return HealthGetResponse{}, err
		}

		var healthsDoc HealthsDoc
		if err := doc.DataTo(&healthsDoc); err != nil {
			return HealthGetResponse{}, err
		}

		healths = append(healths, Healths{
			Id:     doc.Ref.ID,
			Date:   healthsDoc.Date,
			Health: healthsDoc.Health,
		})
	}

	return HealthGetResponse{Healths: healths}, nil
}

// データベースに健康状態のデータを保存する関数
func PostHelthData(userId string, queryData HealthsDoc) (PostResponse, error) {
	return postData(userId, queryData, healthCollec, healthSubCollec)
}

// データベースから睡眠時間のデータを保存する関数
func GetSleepTimeData(userId string, oldDateAt time.Time) (SleepTimeGetResponse, error) {
	client, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return SleepTimeGetResponse{}, err
	}
	defer client.Close()

	query := client.Collection(sleepTimeCollec).Doc(userId).Collection(sleepTimeSubCollec)
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(context.Background())
	var sleepTimes []SleepTimes
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return SleepTimeGetResponse{}, err
		}

		var sleepTimesDoc SleepTimesDoc
		if err := doc.DataTo(&sleepTimesDoc); err != nil {
			return SleepTimeGetResponse{}, err
		}

		sleepTimes = append(sleepTimes, SleepTimes{
			Id:        doc.Ref.ID,
			Date:      sleepTimesDoc.Date,
			SleepTime: sleepTimesDoc.SleepTime,
		})
	}

	return SleepTimeGetResponse{SleepTimes: sleepTimes}, nil
}

// データベースに睡眠時間のデータを保存する関数
func PostSleepTimeData(userId string, queryData SleepTimesDoc) (PostResponse, error) {
	return postData(userId, queryData, sleepTimeCollec, sleepTimeSubCollec)
}

// データベースからメッセージデータを取得する関数
func GetMessageData(userId string, oldDateAt time.Time) (MessageGetResponse, error) {
	client, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return MessageGetResponse{}, err
	}
	defer client.Close()

	query := client.Collection(messageCollec).Doc(userId).Collection(messageSubCollec)
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(context.Background())
	var messages []Messages
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return MessageGetResponse{}, err
		}

		var messagesDoc MessagesDoc
		if err := doc.DataTo(&messagesDoc); err != nil {
			return MessageGetResponse{}, err
		}

		messages = append(messages, Messages{
			Id:       doc.Ref.ID,
			Date:     messagesDoc.Date,
			Question: messagesDoc.Question,
			Answer:   messagesDoc.Answer,
		})
	}

	return MessageGetResponse{Messages: messages}, nil
}

// データベースにGPTとの会話テキストデータを保存する関数
func PostMessageData(userId string, queryData MessagesDoc) (PostResponse, error) {
	return postData(userId, queryData, messageCollec, messageSubCollec)
}

func postData(userId string, queryData interface{}, collec string, subCollec string) (PostResponse, error) {
	client, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return PostResponse{}, err
	}
	defer client.Close()

	_, _, err = client.Collection(collec).Doc(userId).Collection(subCollec).Add(context.Background(), queryData)
	if err != nil {
		return PostResponse{}, err
	}

	return PostResponse{Message: statusOk}, nil
}
