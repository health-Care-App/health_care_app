package firebaseInit

import (
	"context"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"google.golang.org/api/option"
)

func adminSDKInitializer() (*firebase.App, context.Context) {
	sa := option.WithCredentialsFile("../serviceAccountKey.json")
	ctx := context.Background()
	conf := &firebase.Config{ProjectID: "health-care-app-3e333"}
	app, err := firebase.NewApp(ctx, conf, sa)
	if err != nil {
		log.Fatalln(err)
	}
	return app, ctx
}

func FirestoreInitializer() (*firestore.Client, context.Context) {
	app, ctx := adminSDKInitializer()
	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalln(err)
	}
	return client, ctx
}

func AuthInitializer() *auth.Client {
	app, ctx := adminSDKInitializer()
	client, err := app.Auth(ctx)
	if err != nil {
		log.Fatalln(err)
	}
	return client
}
