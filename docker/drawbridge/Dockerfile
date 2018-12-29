# -------- BUILDER ----------
FROM golang:1.10-alpine as builder

MAINTAINER Alex Kawas <vulcanize.io>

# this only works because the context is set in the docker-compose config to be the repo root
COPY . /go/src/github.com/vulcanize/drawbridge

ENV GODEBUG netdns=cgo

WORKDIR $GOPATH/src/github.com/vulcanize/drawbridge

RUN apk add --no-cache \
    alpine-sdk \
    nodejs \
    nodejs-npm \
    python \
    make \
&&  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
&&  cd /go/src/github.com/vulcanize/drawbridge \
&&  mv /go/src/github.com/vulcanize/drawbridge/docker/drawbridge/abigen /bin/ \
&&  go get -v github.com/ethereum/go-ethereum \
&&  dep ensure -v \
&&  cp -r \
        "/go/src/github.com/ethereum/go-ethereum/crypto/secp256k1/libsecp256k1" \
        "vendor/github.com/ethereum/go-ethereum/crypto/secp256k1/" \
&&  make compile

# --------- FINAL -----------

FROM alpine as final

COPY --from=builder /go/src/github.com/vulcanize/drawbridge/build/drawbridge /bin/
COPY alice-config.yml /root/
COPY bob-config.yml /root/
COPY docker/lnd/admin.macaroon /root/
COPY docker/btcd/rpc.cert /root/
