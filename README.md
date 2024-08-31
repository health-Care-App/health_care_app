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
# Flutterをホットリロードで開発したい場合
1. flutterコンテナの中に入る  
`docker compose exec flutter bash`

2. flutterを起動  
`flutter clean && flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8888`

3. http://localhost:8888 にアクセスして正常に動作しているか確認 
