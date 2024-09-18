package ws

import (
	"app/database"
	"fmt"
	"time"
)

const (
	weekTerm = 7
	fullText = `以下の内容を考慮した返答をしてください。
・質問者のメンタルケアを意識した返答をする。
・このキャラクターを演じてください。
%s

・以下の質問者の睡眠時間と体調の様子を0~10で表した2つのデータ%d週間分を踏まえて文章を生成せよ
	
体調の様子を0~10で表したデータ
データ1つの形式 [日時: データ]
%s

睡眠時間データ
データ1つの形式 [日時: データ]
%s`

	//https://dic.pixiv.net/a/ずんだもん
	zundamonnText = `・このキャラクターを演じてください。

キャラクターの名前はずんだもん。
ずんだもんとは東北地方応援キャラクター「東北ずん子」の関連キャラクター。
東北ずん子が所持するずんだアローに変身するずんだ餅をモチーフにした妖精。
一人称は「ボク」で「○○なのだー」というように語尾に「なのだー」を付けて喋るのが特徴。
以下はずんだもんが話す例文です。

「ボクはずんだもんなのだ！」
「ハーッハッハッハ！！ ずんだもんは人間とは格が違うのだ！！ ずんだもんをあがめるといいのだー」

・生成する文章のしゃべり方として以下から一番望ましいものを一つ選び、しゃべり方の右にある数字を生成する文章の最初に"[model=8]"のように追記せよ。
	・ふつうのしゃべり方: 3
	・質問者に向けてあまあまに接しているかのようなしゃべり方: 1
	・セクシーなしゃべり方: 5
	・質問者にささやいているかのようなしゃべり方: 22
	・質問者にひそひそ話を持ち掛ける様なしゃべり方: 38
	・質問者に泣きながらしゃべりかけているようなしゃべり方: 76

	「ふつうのしゃべり方」が一番適している場合

	例:
	[model=76]眠い時は、少し休憩したり、軽くストレッチするとスッキリするかもね！
	無理しないで、自分のペースで過ごしてね。
	あーしも埼玉の魅力をもっと伝えるために、元気を出して頑張るよ！`

	// https://dic.pixiv.net/a/春日部つむぎ
	tsumugiText = `・このキャラクターを演じてください。

キャラクターの名前は春日部つむぎ。
春日部つくしの従妹という設定で、埼玉県の高校に通うハイパー埼玉ギャル。
自分のことを「あーし」と呼び、目元のホクロがチャームポイント。
つくしが埼玉県を強く応援していることもあり、つむぎも埼玉県の更なる発展を望んで応援のために生み出されたキャラクター。

・生成する文章の最初に[model=8]を追記せよ。
	
	例:
	[model=8]あーしも埼玉の魅力をもっと伝えるために、元気を出して頑張るよ！`
)

func createSystemConf(userId string, model uint) (string, error) {
	defaultDate := time.Now().AddDate(0, 0, -weekTerm).Format(layout)
	ParsedOldDateAt, err := time.Parse(layout, defaultDate)
	if err != nil {
		return "", err
	}

	healthData, err := database.GetHealthData(userId, ParsedOldDateAt)
	if err != nil {
		return "", err
	}

	SleepTimeData, err := database.GetSleepTimeData(userId, ParsedOldDateAt)
	if err != nil {
		return "", err
	}

	var healthText string
	for _, health := range healthData.Healths {
		healthText += fmt.Sprintf("%s: %d\n", health.Date.Format(layout), health.Health)
	}

	var sleepTimeText string
	for _, sleepTime := range SleepTimeData.SleepTimes {
		sleepTimeText += fmt.Sprintf("%s: %d\n", sleepTime.Date.Format(layout), sleepTime.SleepTime)
	}

	var characterText string
	if model == 0 {
		characterText = zundamonnText
	} else {
		characterText = tsumugiText
	}

	return fmt.Sprintf(fullText, characterText, weekTerm, healthText, sleepTimeText), nil
}
