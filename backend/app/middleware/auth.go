package middleware

import (
	"app/firebaseinit"
	"strings"

	"github.com/gin-gonic/gin"
)

func Authorized() gin.HandlerFunc {
	return func(c *gin.Context) {
		client, ctx := firebaseinit.AuthInitializer()

		authHeader := c.GetHeader("Authorization")
		idToken := strings.Replace(authHeader, "Bearer ", "", 1)

		token, err := client.VerifyIDToken(ctx, idToken)
		if err != nil {
			c.JSON(401, gin.H{"message": "error verifying ID token"})
		}
		c.Set("userId", token.UID)
		c.Next()
	}
}