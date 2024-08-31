# 技術スタック
## フロントエンド
Dart, flutter  
本番サーバ: https://health-care-app-3e333.web.app  
開発サーバ: http://localhost:4000  
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