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
Docker, Firebase, Cloud Run, Github Actions  
# 環境構築手順
1. リポジトリのクローン  
`git clone git@github.com:health-Care-App/health_care_app.git`
  
2. health_care_appディレクトリでイメージをビルドする(めっちゃ時間かかる。)  
`docker compose build`
  
3. コンテナ起動コマンド  
`docker compose up -d`

4. http://localhost:4000 にアクセスして正常に動作しているか確認  
