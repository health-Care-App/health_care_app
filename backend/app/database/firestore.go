package database

import (
	"app/firebaseinit"
	"time"

	"google.golang.org/api/iterator"
)

// データベースから健康状態のデータを取得する関数
func GetHealthData(userId string, oldDateAt time.Time) (HealthGetResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return HealthGetResponse{}, err
	}
	defer client.Close()

	query := client.Collection("health").Doc(userId).Collection("healths")
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var healths []Healths
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return HealthGetResponse{}, err
		}

		healths = append(healths, Healths{
			Id:     doc.Ref.ID,
			Date:   doc.Data()["Date"].(time.Time),
			Health: doc.Data()["health"].(int64),
		})
	}

	return HealthGetResponse{Healths: healths}, nil
}

// データベースに健康状態のデータを保存する関数
func PostHelthData(userId string, queryData PostHelthDataQuery) (PostResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return PostResponse{}, err
	}
	defer client.Close()

	_, _, err = client.Collection("health").Doc(userId).Collection("healths").Add(ctx, queryData)
	if err != nil {
		return PostResponse{}, err
	}

	return PostResponse{Message: "ok"}, nil
}

// データベースから睡眠時間のデータを保存する関数
func GetSleepTimeData(userId string, oldDateAt time.Time) (SleepTimeGetResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return SleepTimeGetResponse{}, err
	}
	defer client.Close()

	query := client.Collection("sleepTime").Doc(userId).Collection("sleepTimes")
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var sleepTimes []SleepTimes
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return SleepTimeGetResponse{}, err
		}

		sleepTimes = append(sleepTimes, SleepTimes{
			Id:        doc.Ref.ID,
			Date:      doc.Data()["Date"].(time.Time),
			SleepTime: doc.Data()["sleepTime"].(int64),
		})
	}

	return SleepTimeGetResponse{SleepTimes: sleepTimes}, nil
}

// データベースに睡眠時間のデータを保存する関数
func PostSleepTimeData(userId string, queryData PostSleepTimeDataQuery) (PostResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return PostResponse{}, err
	}
	defer client.Close()

	_, _, err = client.Collection("sleepTime").Doc(userId).Collection("sleepTimes").Add(ctx, queryData)
	if err != nil {
		return PostResponse{}, err
	}

	return PostResponse{Message: "ok"}, nil
}

// データベースからメッセージデータを取得する関数
func GetMessageData(userId string, oldDateAt time.Time) (MessageGetResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return MessageGetResponse{}, err
	}
	defer client.Close()

	query := client.Collection("message").Doc(userId).Collection("messages")
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var messages []Messages
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return MessageGetResponse{}, err
		}

		messages = append(messages, Messages{
			Id:   doc.Ref.ID,
			Who:  doc.Data()["who"].(string),
			Date: doc.Data()["Date"].(time.Time),
			Text: doc.Data()["text"].(string),
		})
	}

	return MessageGetResponse{Messages: messages}, nil
}

// データベースにGPTとの会話テキストデータを保存する関数
func PostMessageData(userId string, queryData PostMessageDataQuery) (PostResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return PostResponse{}, err
	}
	defer client.Close()

	_, _, err = client.Collection("message").Doc(userId).Collection("mesasges").Add(ctx, queryData)
	if err != nil {
		return PostResponse{}, err
	}

	return PostResponse{Message: "ok"}, nil
}
