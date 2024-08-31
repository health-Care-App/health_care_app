package database

import (
	"context"
	"log"

	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

func FiresoreInitializer() *firebase.App {
	option.WithCredentialsFile("serviceAccountKey.json")
	ctx := context.Background()
	conf := &firebase.Config{ProjectID: "health-care-app-3e333"}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		log.Fatalln(err)
	}
	return app
}
