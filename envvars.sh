#!/usr/bin/env bash

export GODEBUG=netdns=cgo

if [ -z "$GOPATH" ]; then
  echo "Setting \$GOPATH"
  export GOPATH=$HOME/.go
fi

if [ -z "$DATABASE_URL" ]; then
  echo "Setting \$DATABASE_URLs"
  export DATABASE_URL=postgres://postgres@localhost:5432/drawbridge?sslmode=disable
  export DATABASE_URL_2=postgres://postgres@localhost:5432/drawbridge_2?sslmode=disable
fi
