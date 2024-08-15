FROM golang:1.22.3
WORKDIR /app/

RUN go install github.com/air-verse/air@latest

COPY go.mod go.sum ./
RUN go mod download

COPY ./ /app/

CMD ["air", "-c", ".air.toml"]