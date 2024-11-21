package middleware

import (
	"app/common"
	"app/firebaseinit"
	"context"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func Authorized() gin.HandlerFunc {
	return func(c *gin.Context) {
		client, err := firebaseinit.AuthInitializer()
		if err != nil {
			common.ErrorResponse(c, err, http.StatusInternalServerError)
			c.Abort()
			return
		}

		authHeader := c.GetHeader("Authorization")
		idToken := strings.Replace(authHeader, "Bearer ", "", 1)

		token, err := client.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			common.ErrorResponse(c, err, http.StatusUnauthorized)
			c.Abort()
			return
		}

		c.Set("userId", token.UID)
		c.Next()
	}
}

func WsAuthorized() gin.HandlerFunc {
	return func(c *gin.Context) {
		client, err := firebaseinit.AuthInitializer()
		if err != nil {
			common.ErrorResponse(c, err, http.StatusInternalServerError)
			c.Abort()
			return
		}

		idToken := c.Query("idToken")
		token, err := client.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			common.ErrorResponse(c, err, http.StatusUnauthorized)
			c.Abort()
			return
		}

		c.Set("userId", token.UID)
		c.Next()
	}
}
