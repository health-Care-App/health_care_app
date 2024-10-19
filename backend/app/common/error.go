package common

import (
	"log"

	"github.com/gin-gonic/gin"
)

func ErrorResponse(c *gin.Context, err error, errCode int) {
	log.Println(err)
	c.JSON(errCode, ErrResponse{
		Error: err.Error(),
	})
}

func UserErrorResponse(c *gin.Context, errCode int) {
	log.Println("invalid userId")
	c.JSON(errCode, ErrResponse{
		Error: `invalid userId`,
	})
}
