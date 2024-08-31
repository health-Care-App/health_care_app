package database

import (
	"app/firebaseInit"
	"fmt"
	"log"
	"time"

	"google.golang.org/api/iterator"
)

// データベースから健康状態のデータを取得する関数
func GetHealthData(userId string, oldDateAt time.Time) {
	client, ctx := firebaseInit.FirestoreInitializer()
	iter := client.Collection("health").Where("userId", "==", userId).Where("Date", ">=", oldDateAt).Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalln(err)
		}
		fmt.Println(doc.Data())
	}
}

// データベースに健康状態のデータを保存する関数
func PostHelthData() {
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
