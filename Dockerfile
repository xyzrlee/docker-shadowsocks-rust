#
# Dockerfile for shadowsocks-libev
#

FROM rust:alpine AS builder

RUN set -ex \
 && apk add --no-cache musl-dev \
 && rustup toolchain install nightly \
 && cargo +nightly install shadowsocks-rust \
 && which ssserver 

FROM alpine

COPY --from=builder /usr/local/cargo/bin/ss* /usr/local/bin/

RUN set -ex \
 && which ssserver \
 && ssserver --version

LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"
