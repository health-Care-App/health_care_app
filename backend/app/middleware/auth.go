package middleware

import (
	"app/firebaseinit"
	"strings"

	"github.com/gin-gonic/gin"
)

func Authorized() gin.HandlerFunc {
	return func(c *gin.Context) {
		client, ctx, err := firebaseinit.AuthInitializer()
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			c.Abort()
		}

		authHeader := c.GetHeader("Authorization")
		idToken := strings.Replace(authHeader, "Bearer ", "", 1)
		token, err := client.VerifyIDToken(ctx, idToken)
		if err != nil {
			c.JSON(401, gin.H{"error": err.Error()})
			c.Abort()
		}

		c.Set("userId", token.UID)
		c.Next()
	}
}
