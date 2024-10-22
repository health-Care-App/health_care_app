package middleware

import (
	"app/common"
	"app/firebaseinit"
	"context"
	"strings"

	"github.com/gin-gonic/gin"
)

func Authorized() gin.HandlerFunc {
	return func(c *gin.Context) {
		client, err := firebaseinit.AuthInitializer()
		if err != nil {
			common.ErrorResponse(c, err, common.InternalErrCode)
			c.Abort()
			return
		}

		authHeader := c.GetHeader("Authorization")
		idToken := strings.Replace(authHeader, "Bearer ", "", 1)

		token, err := client.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			common.ErrorResponse(c, err, common.ExternalErrCode)
			c.Abort()
			return
		}

		c.Set("userId", token.UID)
		c.Next()
	}
}
