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

	defer client.Close()
	return HealthGetResponse{Healths: healths}, nil
}

// データベースに健康状態のデータを保存する関数
func PostHelthData(userId string, health int, createDateAt time.Time) (PostResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return PostResponse{}, err
	}

	_, _, err = client.Collection("health").Doc(userId).Collection("healths").Add(
		ctx, PostHelthDataQuery{
			Health: health,
			Date:   createDateAt,
		},
	)
	if err != nil {
		return PostResponse{}, err
	}

	defer client.Close()
	return PostResponse{Message: "ok"}, nil
}

// データベースから睡眠時間のデータを保存する関数
func GetSleepTimeData(userId string, oldDateAt time.Time) (SleepTimeGetResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return SleepTimeGetResponse{}, err
	}

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

	defer client.Close()
	return SleepTimeGetResponse{SleepTimes: sleepTimes}, nil
}

// データベースに睡眠時間のデータを保存する関数
func PostSleepTimeData(userId string, sleepTime int, createDateAt time.Time) (PostResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return PostResponse{}, err
	}

	_, _, err = client.Collection("sleepTime").Doc(userId).Collection("sleepTimes").Add(
		ctx, PostSleepTimeDataQuery{
			SleepTime: sleepTime,
			Date:      createDateAt,
		},
	)
	if err != nil {
		return PostResponse{}, err
	}

	defer client.Close()
	return PostResponse{Message: "ok"}, nil
}

// データベースからメッセージデータを取得する関数
func GetMessageData(userId string, oldDateAt time.Time) (MessageGetResponse, error) {
	client, ctx, err := firebaseinit.FirestoreInitializer()
	if err != nil {
		return MessageGetResponse{}, err
	}

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

	defer client.Close()
	return MessageGetResponse{Messages: messages}, nil
}
