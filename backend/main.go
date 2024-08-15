package main

import (
    "github.com/gin-gonic/gin"
    "net/http"
    "fmt"
)

type Result struct {
    Id int
    Name string
}

func main() {
    fmt.Println("hello world")
}