FROM golang:1.25.4-alpine3.21 AS builder
LABEL org.opencontainers.image.source=https://github.com/ihor-drachuk/kcptun-archive
ENV GO111MODULE=on
COPY . /src
RUN cd /src && \
	go build -mod=vendor -ldflags "-X main.VERSION=$(date -u +%Y%m%d) -s -w" -o /client github.com/dumbybumby/kcptun-archive/client && \
	go build -mod=vendor -ldflags "-X main.VERSION=$(date -u +%Y%m%d) -s -w" -o /server github.com/dumbybumby/kcptun-archive/server

FROM alpine:3.18
RUN apk add --no-cache iptables
COPY --from=builder /client /bin
COPY --from=builder /server /bin
EXPOSE 29900/udp
EXPOSE 12948
