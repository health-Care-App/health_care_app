FROM golang:1.22.3
WORKDIR /app/

RUN go install github.com/air-verse/air@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest

COPY ./app/go.mod ./app/go.sum ./
RUN go mod download

COPY ./app/ /app/

RUN curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/download-linux-x64 -o download \
    && chmod +x download \
    && ./download \
    && rm ./download

#シンボリックを設定
RUN ln -s /app/voicevox_core/libvoicevox_core.so /usr/lib \
    && ln -s /app/voicevox_core/libonnxruntime.so.1.13.1 /usr/lib \
    && ln -s /app/voicevox_core/model /usr/lib/model \
    && ln -s /app/voicevox_core/voicevox_core.h /usr/include

EXPOSE 8080
CMD [ "air", "-c", ".air.toml" ]