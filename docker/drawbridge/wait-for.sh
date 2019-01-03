#!/bin/sh
# wait-for.sh

set -e
truffle="$1"
shift
cmd="$@"

# wait-on waits until ganache's port is open
# sleep waits the extra so many seconds ganache takes to migrate contracts
wait-on $truffle && sleep 25 && $cmd
