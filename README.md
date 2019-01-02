## Running Drawbridge (prototype) for deployment

### 1. Clone into $GOPATH
```
git clone git@github.com:vulcanize/drawbridge $GOPATH/src/github.com/vulcanize/drawbridge
```

### 2. Build images, create and run containers
```
cd docker && docker-compose up
```

## Running Drawbridge (prototype) locally for development

### 0. TL;DR macOS/Homebrew setup
```
git clone git@github.com:vulcanize/drawbridge $GOPATH/src/github.com/vulcanize/drawbridge
cd $GOPATH/src/github.com/vulcanize/drawbridge
source envvars.sh
make setup && make dep && make migrate-both-databases
make develop >> ganache.log 2>&1 &
make migrate-contracts
cd docker && docker-compose up
cd ..
make start >> db_alice.log 2>&1 &
./start-drawbridge.sh >> db_bob.log 2>&1 &
```


### 1. Requirements
- [postgres](https://postgresql.org)
- [nodejs & npm](https://nodejs.org)
- [go 1.10 (under Archived Versions)](https://golang.org/dl)
- [golang-migrate](https://github.com/golang-migrate/migrate)
- [docker & docker-compose](https://docker.com)
- [geth & abigen](https://github.com/ethereum/go-ethereum)


#### Meeting requirements on macOS with Homebrew
If you're running macOS, use Homebrew, and already have some of the requirements, skip to what you need.

You can use the included script to automatically check for the necessary requirements. If you've updated to bash 4, it will also install them for you.
```
make require
```

##### Postgres
```
brew install postgres
pg_ctl -D /usr/local/var/postgres start
```
##### Nodejs & npm
```
brew install nodenv
nodenv install 11.3.0
nodenv global 11.3.0
```
or locally within repository:
```
nodenv local 11.3.0
```
##### Go
```
brew install goenv
goenv install 1.10.0
goenv global 1.10.0
```
or locally within repository:
```
goenv local 1.10.0
```
##### golang-migrate
```
brew install golang-migrate
```
##### Docker
```
brew cask install docker
```
##### geth & abigen
```
brew tap ethereum/ethereum
brew install ethereum
```

### 2. Clone this repo in $GOPATH
```
git clone git@github.com:vulcanize/drawbridge $GOPATH/src/github.com/vulcanize/drawbridge
```

### 3. Prepare environment
```
cd $GOPATH/src/github.com/vulcanize/drawbridge
source envvars.sh
make setup
```

### 4. Build drawbridge
```
make dep
make compile
```

### 5. Setup databases
```
make migrate-both-databases
```

### 6. Build images, create and run containers <a name="buildandrun"></a>
```
cd docker && docker-compose up
```

### 7. Setup Ethereum node and create Lightning payment contracts
```
make develop >> ganache.log 2>&1 &
make migrate-contracts
```

### 8. Run 2 Drawbridge services
```
make start >> db_alice.log 2>&1 &
./start-drawbridge.sh >> db_bob.log 2>&1 &
```

## Testing Drawbridge
```
cd solidity
make develop >> test.log 2>&1 &
cd ..
make test
./integration-test.sh
```
