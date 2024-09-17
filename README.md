# 技術スタック
## フロントエンド
Dart, flutter  
  
本番サーバ: https://health-care-app-3e333.web.app  
  
FirebaseのAuthentication、FireStore、Hosting機能を模したEmulator開発サーバ: http://localhost:4000  
※コードを書き直した後、その変化が即反映されないので、Flutterのコーディングするときの利用は非推奨  
  
Flutterを直接起動した開発サーバ（[Flutterをホットリロードで開発したい場合](https://github.com/health-Care-App/health_care_app#flutter%E3%82%92%E3%83%9B%E3%83%83%E3%83%88%E3%83%AA%E3%83%AD%E3%83%BC%E3%83%89%E3%81%A7%E9%96%8B%E7%99%BA%E3%81%97%E3%81%9F%E3%81%84%E5%A0%B4%E5%90%88)で起動する必要あり）: http://localhost:8888  
※コードの書き直しが即反映されるホットリロードが有効なため、Flutterのコーディングをするときはこちらを推奨
## バックエンド
Go, Gin  
  
本番サーバ: https://go-server-ielplqf5oa-uc.a.run.app  
開発サーバ: http://localhost:8080  
## 開発環境
- Docker  
  仮想コンテナ
- Firebase  
  主にフロントのデプロイ先、ユーザー認証、DB
- Cloud Run  
  主にバックエンドのデプロイ先
- Github Actions  
  mainにマージした時、自動でデプロイしてくれる役割
- Swagger  
  apiとスキーマ定義できるツール [ここで定義してます](https://app.swaggerhub.com/apis/SUISAN0731_1/healthCareAppApi/1.0.0)
# 環境構築手順
1. リポジトリのクローン  
`git clone git@github.com:health-Care-App/health_care_app.git`
  
2. health_care_appディレクトリでイメージをビルドする(めっちゃ時間かかる。)  
`docker compose build`
  
3. コンテナ起動コマンド  
`docker compose up -d`

4. http://localhost:4000 にアクセスして正常に動作しているか確認  
## Flutterをホットリロードで開発したい場合
1. flutterコンテナの中に入る  
`docker compose exec flutter bash`

2. flutterを起動  
`flutter clean && flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8888`

3. http://localhost:8888 にアクセスして正常に動作しているか確認

# APIとwebsocket
データの送受信は基本的にAPIとwebsocketを利用しています。  
2つの方式どちらもリクエストのヘッダーパラメータ`Authorization`にfirebaseのユーザー認証トークン`idToken`を指定する必要があります。 
```
"Authorization": "Bearer idToken"
```
例:  
```
"Authorization": "Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJuYW1lIjoic2hvZ28iLCJwaWN0dXJlIjoiIiwiZW1haWwiOiJzdWlzYW4wNzMxQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiYXV0aF90aW1lIjoxNzI2NTg5NjIxLCJ1c2VyX2lkIjoiSTBWc0k1Q3lvbENsT0Q0Zkxld1BZTldDUmxlcCIsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsic3Vpc2FuMDczMUBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9LCJpYXQiOjE3MjY1ODk2MjEsImV4cCI6MTcyNjU5MzIyMSwiYXVkIjoiaGVhbHRoLWNhcmUtYXBwLTNlMzMzIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL2hlYWx0aC1jYXJlLWFwcC0zZTMzMyIsInN1YiI6IkkwVnNJNUN5b2xDbE9ENGZMZXdQWU5XQ1JsZXAifQ."
```
## API
Swaggerを参照。  
https://app.swaggerhub.com/apis/SUISAN0731_1/healthCareAppApi/1.0.0
## websocket
音声合成のみwebsocketを利用しています。  
リクエストはJSON形式、レスポンスは一文で区切った音声データをbase64形式で返します。返答が2文以上ある場合その数と同数のデータを返します。  

```
# リクエスト
# question: 質問文を指定
# model: ずんだもんの場合0, 春日つむぎの場合1を指定

{
  question: "質問"
  model: 0
}
```

```
# レスポンス
# base64

"UklGRiRWAgBXQVZFZm10IBAAAAABAAEAwF0AAIC7AAACABAAZGF0YQBWAgAAAA ... AAA///9//r/+v/6//v/+//5//n/+v/6//v/+//7//r/+f/5//n/+f/5//f/"
```
