FROM golang:1.12.1 as builder

# Copy the code from the host and compile it
WORKDIR $GOPATH/src/github.com/rmeharg/go-rabbitmq-pubsub

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go install ./...

FROM scratch
COPY --from=builder /go/bin/receive /go/bin/send /usr/local/bin/
CMD ["receive"]
