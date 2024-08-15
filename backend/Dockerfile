FROM golang:1.22.3
WORKDIR /app/
COPY ./ /app/

RUN go get -u github.com/air-verse/air@latest && \
    go build -o /go/bin/air github.com/air-verse/air

ENV HOSTNAME "0.0.0.0"
CMD ["air", "-c", ".air.toml"]