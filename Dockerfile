#
# Dockerfile for shadowsocks-rust
#

FROM alpine AS builder

ARG ALPINE_MIRROR=""
ARG BUILD_SCRIPT="alpine-build.sh"
ARG BUILD_ROOT="/build"

COPY ${BUILD_SCRIPT} /build.sh

RUN set -ex \
 && ls -alh / \
 && mkdir ${BUILD_ROOT} \
 && cd ${BUILD_ROOT} \
 && chmod +x /build.sh \
 && /build.sh

# ------------------------------------------------

FROM alpine

ARG BUILD_ROOT="/build"

COPY --from=builder /${BUILD_ROOT}/sslocal /usr/local/bin/
COPY --from=builder /${BUILD_ROOT}/ssmanager /usr/local/bin/
COPY --from=builder /${BUILD_ROOT}/ssserver /usr/local/bin/
COPY --from=builder /${BUILD_ROOT}/ssurl /usr/local/bin/

RUN set -ex \
 && which ssserver \
 && ssserver --version

LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"
