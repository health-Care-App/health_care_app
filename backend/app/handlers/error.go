package handlers

import (
	"log"

	"github.com/gin-gonic/gin"
)

func errorResponse(c *gin.Context, err error) {
	log.Println(err)
	c.JSON(500, gin.H{
		"error": err.Error(),
	})
	c.Abort()
}

func userErrorResponse(c *gin.Context) {
	log.Println("invalid userId")
	c.JSON(500, gin.H{
		"error": "invalid userId",
	})
	c.Abort()
}
