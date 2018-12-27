FROM golang:1.10-alpine as final
  
MAINTAINER Alex Kawas <vulcanize.io>

RUN mkdir /code

# Set working directory
WORKDIR /code

EXPOSE 8545

# Install Truffle
RUN apk add --no-cache \
    alpine-sdk \
    nodejs \
    nodejs-npm \
    python \
    bash \
&&  npm -g config set user root \
&&  npm install -g truffle@4.1.14 \
&&  npm install -g ganache-cli

COPY solidity solidity

RUN  cd solidity \
&&  npm install --ignore-scripts

COPY Makefile .
COPY start-truffle.sh .
RUN chmod +x start-truffle.sh
