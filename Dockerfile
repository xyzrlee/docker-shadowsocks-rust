#
# Dockerfile for shadowsocks-rust
#

FROM alpine AS builder

ARG ALPINE_MIRROR=""
ARG BUILD_SCRIPT="alpine-build.sh"
ARG BUILD_ROOT="/build"

COPY ${BUILD_SCRIPT} /build.sh

RUN set -ex \
 && mkdir ${BUILD_ROOT} \
 && cd ${BUILD_ROOT} \
 && chmod +x /build.sh \
 && /build.sh

# ------------------------------------------------

FROM alpine

ARG ALPINE_MIRROR=""
ARG BUILD_ROOT="/build"
ARG TARGET="/usr/local/bin"

COPY --from=builder /${BUILD_ROOT}/sslocal          ${TARGET}
COPY --from=builder /${BUILD_ROOT}/ssmanager        ${TARGET}
COPY --from=builder /${BUILD_ROOT}/ssserver         ${TARGET}
COPY --from=builder /${BUILD_ROOT}/ssurl            ${TARGET}

RUN set -ex \
 && if [ -n "${ALPINE_MIRROR}" ]; then sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_MIRROR}/g" /etc/apk/repositories; fi \
 && apk add --no-cache \
        $(scanelf --needed --nobanner /usr/local/bin/ss* | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | xargs -r apk info --installed | sort -u) \
 && which ssserver \
 && ssserver --version

LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"
