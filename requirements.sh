#!/usr/bin/env bash

echo "Checking bash version... $BASH_VERSION"

INSTALL=true
if [[ ! $BASH_VERSION =~ ^[4-9] ]]; then # this will break for bash 10, but that's a long way off
  INSTALL=false
  echo "Note: This script requires bash 4's support of associative arrays to install requirements for you"
fi

echo "Checking for requirements..."

declare -a REQS=("brew" "postgres" "node" "go" "migrate" "docker" "geth" "dep" "truffle")

if $INSTALL; then
  declare -A INSTALLERS
  INSTALLERS[brew]="/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
  INSTALLERS[postgres]="brew install postgres"
  INSTALLERS[node]="brew install nodenv && nodenv install 10.14.0 && nodenv global 10.14.0"
  INSTALLERS[go]="brew install goenv && goenv install 1.10.0 && goenv global 1.10.0"
  INSTALLERS[migrate]="brew install golang-migrate"
  INSTALLERS[docker]="brew cask install docker"
  INSTALLERS[geth]="brew tap ethereum/ethereum && brew install ethereum"
  INSTALLERS[dep]="curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"
  INSTALLERS[truffle]="npm install -g truffle@^4.0.0"
fi

for CMD in "${REQS[@]}"; do
  output=(`which $CMD`)
  if [ $? -ne 0 ]; then
    echo "Missing $CMD. Installing..."
    echo "${INSTALLERS[$CMD]}"
  else
    echo "Found $CMD: ${output}"
  fi
done

