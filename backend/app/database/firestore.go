package database

import (
	"app/firebaseInit"
	"log"
	"time"

	"google.golang.org/api/iterator"
)

type dict map[string]interface{}
type list []dict
type getHealthResponse map[string]interface{}

// データベースから健康状態のデータを取得する関数
func GetHealthData(userId string, oldDateAt time.Time) getHealthResponse {
	client, ctx := firebaseInit.FirestoreInitializer()
	query := client.Collection("health").Doc(userId).Collection("healths")
	getHealthQuery := query.Where("Date", ">=", oldDateAt).Documents(ctx)
	var response list
	for {
		doc, err := getHealthQuery.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalln(err)
		}
		response = append(response, dict{
			"id":     doc.Ref.ID,
			"Date":   doc.Data()["Date"],
			"health": doc.Data()["health"],
		})
	}
	return getHealthResponse{"healths": response}
}

// データベースに健康状態のデータを保存する関数
func PostHelthData(userId string, health int, createDateAt time.Time) {
	client, ctx := firebaseInit.FirestoreInitializer()
	_, _, err := client.Collection("health").Doc(userId).Collection("healths").Add(
		ctx, map[string]interface{}{
			"health": health,
			"Date":   createDateAt,
		},
	)
	if err != nil {
		log.Printf("An error has occurred: %s", err)
	}
}

// データベースから睡眠時間のデータを保存する関数
func GetSleepTimeData() {
}

// データベースに睡眠時間のデータを保存する関数
func PostSleepTimeData() {
}

// データベースからメッセージデータを取得する関数
func GetMessageData() {
}
