#!/bin/sh

set -e

if [ -n "${ALPINE_MIRROR}" ]
then
    echo "ALPINE_MIRROR=${ALPINE_MIRROR}"
    sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_MIRROR}/g" /etc/apk/repositories
fi

apk update
apk add --no-cache jq curl wget

TAGNAME=`curl https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | jq -r .tag_name`

echo "TAGNAME=${TAGNAME}"

TARBALL="shadowsocks-rust.tar.xz"
URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${TAGNAME}/shadowsocks-${TAGNAME}.x86_64-unknown-linux-musl.tar.xz"
wget -O ${TARBALL} ${URL}

tar xvJf ${TARBALL}

pwd
ls -alh
