package middleware

import (
	"app/firebaseinit"
	"context"
	"strings"

	"github.com/gin-gonic/gin"
)

func Authorized() gin.HandlerFunc {
	return func(c *gin.Context) {
		client, err := firebaseinit.AuthInitializer()
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		authHeader := c.GetHeader("Authorization")
		idToken := strings.Replace(authHeader, "Bearer ", "", 1)

		token, err := client.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			c.JSON(401, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		c.Set("userId", token.UID)
		c.Next()
	}
}
