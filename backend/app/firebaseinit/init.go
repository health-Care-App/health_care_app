package firebaseinit

import (
	"context"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
)

const (
	projectId = "health-care-app-3e333"
)

func adminSDKInitializer() (*firebase.App, error) {
	ctx := context.Background()
	conf := &firebase.Config{ProjectID: projectId}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		return nil, err
	}
	return app, nil
}

func FirestoreInitializer() (*firestore.Client, error) {
	app, err := adminSDKInitializer()
	if err != nil {
		return nil, err
	}

	client, err := app.Firestore(context.Background())
	if err != nil {
		return nil, err
	}
	return client, nil
}

func AuthInitializer() (*auth.Client, error) {
	app, err := adminSDKInitializer()
	if err != nil {
		return nil, err
	}

	client, err := app.Auth(context.Background())
	if err != nil {
		return nil, err
	}
	return client, nil
}
