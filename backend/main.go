package main

import (
    "github.com/gin-gonic/gin"
    "net/http"
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
    "fmt"
)

type Result struct {
    Id int
    Name string
}

func main() {
    engine:= gin.Default()
    engine.GET("/", func(c *gin.Context) {
        dsn := "host=db user=healthCareUser password=healthCarePassword dbname=healthCareDB port=5432 sslmode=disable TimeZone=Asia/Tokyo"
	    db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	    if err != nil {
		    fmt.Println("DB error(Init): ", err)
	    }

        // レコードを1行取得
        var result Result
        db.First(&result)

        c.JSON(http.StatusOK, gin.H{
            "test" : result.Name,
        })
    })
    engine.Run(":8080")
}