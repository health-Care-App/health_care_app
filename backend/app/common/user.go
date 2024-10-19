package common

import "github.com/gin-gonic/gin"

func NewUserId(c *gin.Context) string {
	value, exists := c.Get("userId")
	if !exists {
		UserErrorResponse(c, ExternalErrCode)
	}
	return value.(string)
}
