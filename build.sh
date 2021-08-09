#!/bin/bash

docker-compose -f docker-compose-build.yaml build $@

TAGNAME=`curl https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | jq -r .tag_name`
echo "${TAGNAME}" >>TAGNAME