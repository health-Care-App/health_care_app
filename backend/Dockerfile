FROM golang:1.22.3
WORKDIR /app/

RUN go install github.com/air-verse/air@latest

COPY ./app/go.mod ./app/go.sum ./
RUN go mod download

COPY ./app/ /app/

EXPOSE 8080

CMD ["air", "-c", ".air.toml"]