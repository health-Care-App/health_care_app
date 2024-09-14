package database

import (
	"app/firebaseinit"
	"log"
	"time"

	"google.golang.org/api/iterator"
)

// データベースから健康状態のデータを取得する関数
func GetHealthData(userId string, oldDateAt time.Time) HealthGetResponse {
	client, ctx := firebaseinit.FirestoreInitializer()
	query := client.Collection("health").Doc(userId).Collection("healths")
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var healths []Healths
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalln(err)
		}

		healths = append(healths, Healths{
			Id:     doc.Ref.ID,
			Date:   doc.Data()["Date"].(time.Time),
			Health: doc.Data()["health"].(int64),
		})
	}
	defer client.Close()
	return HealthGetResponse{Healths: healths}
}

// データベースに健康状態のデータを保存する関数
func PostHelthData(userId string, health int, createDateAt time.Time) PostResponse {
	client, ctx := firebaseinit.FirestoreInitializer()
	_, _, err := client.Collection("health").Doc(userId).Collection("healths").Add(
		ctx, PostHelthDataQuery{
			Health: health,
			Date:   createDateAt,
		},
	)
	if err != nil {
		log.Fatalln(err)
	}
	defer client.Close()
	return PostResponse{Message: "ok"}
}

// データベースから睡眠時間のデータを保存する関数
func GetSleepTimeData(userId string, oldDateAt time.Time) SleepTimeGetResponse {
	client, ctx := firebaseinit.FirestoreInitializer()
	query := client.Collection("sleepTime").Doc(userId).Collection("sleepTimes")
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var sleepTimes []SleepTimes
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalln(err)
		}

		sleepTimes = append(sleepTimes, SleepTimes{
			Id:        doc.Ref.ID,
			Date:      doc.Data()["Date"].(time.Time),
			SleepTime: doc.Data()["sleepTime"].(int64),
		})
	}
	defer client.Close()
	return SleepTimeGetResponse{SleepTimes: sleepTimes}
}

// データベースに睡眠時間のデータを保存する関数
func PostSleepTimeData(userId string, sleepTime int, createDateAt time.Time) PostResponse {
	client, ctx := firebaseinit.FirestoreInitializer()
	_, _, err := client.Collection("sleepTime").Doc(userId).Collection("sleepTimes").Add(
		ctx, PostSleepTimeDataQuery{
			SleepTime: sleepTime,
			Date:      createDateAt,
		},
	)
	if err != nil {
		log.Fatalln(err)
	}
	defer client.Close()
	return PostResponse{Message: "ok"}
}

// データベースからメッセージデータを取得する関数
func GetMessageData(userId string, oldDateAt time.Time) MessageGetResponse {
	client, ctx := firebaseinit.FirestoreInitializer()
	query := client.Collection("message").Doc(userId).Collection("messages")
	dateQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var messages []Messages
	for {
		doc, err := dateQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalln(err)
		}

		messages = append(messages, Messages{
			Id:   doc.Ref.ID,
			Who:  doc.Data()["who"].(string),
			Date: doc.Data()["Date"].(time.Time),
			Text: doc.Data()["text"].(string),
		})
	}
	defer client.Close()
	return MessageGetResponse{Messages: messages}
}
