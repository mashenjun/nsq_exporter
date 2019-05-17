FROM golang:1.12 as builder
ENV GOPATH /go
RUN mkdir -p $GOPATH/src/github.com/mashenjun/nsq_exporter
COPY ./ $GOPATH/src/github.com/mashenjun/nsq_exporter
WORKDIR $GOPATH/src/github.com/mashenjun/nsq_exporter
RUN go build -ldflags "-X main.buildAt=`date +%FT%T%z`" -o $GOPATH/bin/nsq_exporter main.go

FROM alpine:3.5
LABEL VERSION="1.0"
LABEL DESCRIPTION="nsq_exporter docker image."
LABEL MAINTAINER="mashenjun"
EXPOSE 9117

RUN apk update && apk add --no-cache ca-certificates curl bash tree tzdata \
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ENV TZ=Asia/Shanghai
WORKDIR /
COPY --from=builder /go/bin/nsq_exporter .
CMD ["/nsq_exporter"]
