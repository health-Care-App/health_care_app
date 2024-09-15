package firebaseinit

import (
	"context"
	"os"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"google.golang.org/api/option"
)

func adminSDKInitializer() (*firebase.App, context.Context, error) {
	var app *firebase.App
	var err error

	ctx := context.Background()
	conf := &firebase.Config{ProjectID: "health-care-app-3e333"}

	//PROD環境の場合serviceAccountKey.jsonを読み込む
	if _, isDev := os.LookupEnv("FIRESTORE_EMULATOR_HOST"); !isDev {
		sa := option.WithCredentialsFile("../serviceAccountKey.json")
		app, err = firebase.NewApp(ctx, conf, sa)
	} else {
		app, err = firebase.NewApp(ctx, conf)
	}

	if err != nil {
		return nil, nil, err
	}
	return app, ctx, nil
}

func FirestoreInitializer() (*firestore.Client, context.Context, error) {
	app, ctx, err := adminSDKInitializer()
	if err != nil {
		return nil, nil, err
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		return nil, nil, err
	}
	return client, ctx, nil
}

func AuthInitializer() (*auth.Client, context.Context, error) {
	app, ctx, err := adminSDKInitializer()
	if err != nil {
		return nil, nil, err
	}

	client, err := app.Auth(ctx)
	if err != nil {
		return nil, nil, err
	}
	return client, ctx, nil
}
