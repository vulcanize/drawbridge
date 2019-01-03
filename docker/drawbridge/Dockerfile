# -------- BUILD TRUFFLE ----------
FROM golang:1.10-alpine as buildtruffle

MAINTAINER Alex Kawas <vulcanize.io>

WORKDIR /code

# Install Truffle
RUN apk add --no-cache \
    alpine-sdk \
    nodejs \
    nodejs-npm \
    python \
    bash \
&&  npm -g config set user root \
&&  npm install -g truffle@4.1.14

COPY solidity solidity

RUN  cd solidity \
&&  npm i --ignore-scripts \
&&  make compile

# -------- BUILDER ----------
FROM golang:1.10-alpine as builder

WORKDIR $GOPATH/src/github.com/vulcanize/drawbridge

ENV GODEBUG netdns=cgo

# this only works because the context is set in the docker-compose config to be the repo root
COPY . $GOPATH/src/github.com/vulcanize/drawbridge
COPY --from=buildtruffle /code/solidity/build/ $GOPATH/src/github.com/vulcanize/drawbridge/solidity/build

RUN apk add --no-cache \
    alpine-sdk \
    make \
    python \
    bash \
&&  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
&&  cd $GOPATH/src/github.com/vulcanize/drawbridge \
&&  mv $GOPATH/src/github.com/vulcanize/drawbridge/docker/drawbridge/abigen /bin/ \
&&  go get -v github.com/ethereum/go-ethereum \
&&  dep ensure -v \
&&  cp -r \
        "/go/src/github.com/ethereum/go-ethereum/crypto/secp256k1/libsecp256k1" \
        "vendor/github.com/ethereum/go-ethereum/crypto/secp256k1/" \
&&  make compile

# --------- FINAL -----------

FROM alpine as final

RUN apk add \
    nodejs \
    nodejs-npm \
&&  npm -g config set user root \
&&  npm i -g wait-on

COPY docker/drawbridge/wait-for.sh /
RUN chmod +x wait-for.sh

COPY --from=builder /go/src/github.com/vulcanize/drawbridge/build/drawbridge /bin/
COPY alice-config.yml /root/
COPY bob-config.yml /root/
COPY docker/lnd/admin.macaroon /root/
COPY docker/btcd/rpc.cert /root/
