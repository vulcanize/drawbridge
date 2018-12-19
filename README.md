## Running Drawbridge prototype locally
To build for deployment, clone and skip to [8. Build images, create and run containers](#buildandrun)

### 0. TL;DR macOS/Homebrew setup
```
git clone git@github.com:vulcanize/drawbridge $GOPATH/src/github.com/vulcanize/drawbridge
make require && make setup && make dep && make compile && make setup-database && make migrate-database
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
./requirements.sh
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
export GODEBUG=netdns=cgo
cd $GOPATH/src/github.com/vulcanize/drawbridge
git config url."git@github.com:".insteadOf "https://github.com/"
```

### 4. Install dep and truffle
```
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
npm install -g truffle
```

### 5. Build drawbridge
```
cd solidity
npm i —ignore-scripts
cd ..
go get -v github.com/ethereum/go-ethereum
make dep
make compile
```

### 6. Setup database
```
createuser postgres
createdb drawbridge_2
export DATABASE_URL=postgres://postgres@localhost:5432/drawbridge_2?sslmode=disable
make migrate-database
```

### 7. Construct local config
(TODO)

### 8. Build images, create and run containers <a name="buildandrun"></a>
```
cd docker
docker-compose up
```
