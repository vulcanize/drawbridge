#!/usr/bin/env bash

if [ -z "$GOPATH" ]; then
  echo "setting \$GOPATH"
  export GOPATH=$HOME/.go
fi
