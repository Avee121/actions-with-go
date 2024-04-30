# docker build -t goPost .
# docker run -it goPost

FROM golang:1.22.2-alpine3.19 AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

RUN mkdir /pro
ADD ./usePost05.go /pro/
WORKDIR /pro
COPY go.mod .
COPY go.sum .
COPY usePost05.go .
RUN go install ./...
RUN go build -o server usePost05.go

FROM alpine:latest

RUN mkdir /pro
COPY --from=builder /pro/server /pro/server
WORKDIR /pro
CMD ["/pro/server"]
