#!/usr/bin/env bash

`make develop >> ganache.log 2>&1 &` &&
make compile-contracts
make migrate-contracts
tail -f ganache.log
