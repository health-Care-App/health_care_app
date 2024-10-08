package common

import (
	"log"

	"github.com/gin-gonic/gin"
)

func ErrorResponse(c *gin.Context, err error) {
	log.Println(err)
	c.JSON(500, gin.H{
		"error": err.Error(),
	})
}

func UserErrorResponse(c *gin.Context) {
	log.Println("invalid userId")
	c.JSON(500, gin.H{
		"error": "invalid userId",
	})
}
