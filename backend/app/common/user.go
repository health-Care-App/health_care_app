package common

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func NewUserId(c *gin.Context) string {
	value, exists := c.Get("userId")
	if !exists {
		UserErrorResponse(c, http.StatusBadRequest)
	}
	return value.(string)
}
