package firebaseinit

import (
	"context"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
)

const (
	projectId             = "health-care-app-3e333"
	serviceAccountKeyPath = "serviceAccountKey.json"
)

func adminSDKInitializer() (*firebase.App, context.Context, error) {
	var app *firebase.App
	var err error

	ctx := context.Background()
	conf := &firebase.Config{ProjectID: projectId}
	app, err = firebase.NewApp(ctx, conf)

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
