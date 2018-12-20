#!/usr/bin/env bash

export GODEBUG=netdns=cgo

if [ -z "$GOPATH" ]; then
  echo "Setting \$GOPATH"
  export GOPATH=$HOME/.go
fi

if [ -z "$DATABASE_URL" ]; then
  echo "Setting \$DATABASE_URL"
  export DATABASE_URL=postgres://postgres@localhost:5432?sslmode=disable
fi
