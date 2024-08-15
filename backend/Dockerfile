FROM golang:1.22.3
WORKDIR /app/
COPY ./ /app/

RUN go get -u github.com/air-verse/air@latest

CMD ["air", "-c", ".air.toml"]