require:
	@./requirements.sh

setup: require
	@./gopath.sh
	@echo GOPATH=$(GOPATH)
	export GODEBUG=netdns=cgo
	cd $(GOPATH)/src/github.com/vulcanize/drawbridge
	git config url."git@github.com:".insteadOf "https://github.com/"
	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
	npm install -g truffle
	cd solidity
	npm i —ignore-scripts
	cd ..
	go get -v github.com/ethereum/go-ethereum

setup-database:
	createuser postgres
	createdb drawbridge_2
	export DATABASE_URL=postgres://postgres@localhost:5432/drawbridge_2?sslmode=disable
	
compile-contracts:
	@$(MAKE) -C ./solidity compile

migrate-contracts:
	@$(MAKE) -C ./solidity migrate

migrate-database:
	migrate -database "$(DATABASE_URL)" -path ./migrations up

create-db-migration:
	cd  ./migrations && migrate create -ext sql $(MIGRATION_NAME)

develop:
	@$(MAKE) -C ./solidity testnet

test: compile
	@$(MAKE) -C ./solidity test
	go test ./pkg/...
	go test ./internal/...

compile-extract-abi:
	go build -o build/extract-abi ./cmd/extract_abi.go

abigen: compile-contracts compile-extract-abi
	mkdir -p ./build/abi
	./build/extract-abi --contracts ./solidity/build/contracts/LightningERC20.json,./solidity/build/contracts/ERC20.json --output-dir ./build/abi
	abigen --abi ./build/abi/LightningERC20.json --pkg contracts --type LightningERC20 --out ./pkg/contracts/lighting_erc20.go
	abigen --abi ./build/abi/ERC20.json --pkg contracts --type ERC20 --out ./pkg/contracts/erc20.go

compile: abigen
	go build -gcflags='-N -l' -o ./build/drawbridge ./cmd/drawbridge.go

dep:
	@./gopath.sh
	@echo GOPATH=$(GOPATH)
	dep ensure -v
	cp -r \
      "${GOPATH}/src/github.com/ethereum/go-ethereum/crypto/secp256k1/libsecp256k1" \
      "vendor/github.com/ethereum/go-ethereum/crypto/secp256k1/"

clean:
	@$(MAKE) -C ./solidity clean
	rm -rf ./build
	rm -rf ./pkg/contracts/*.go

start: compile
	./build/drawbridge --config ./local-config.yml

make start-debug: compile
	dlv --listen=:2345 --headless=true --api-version=2 exec ./build/drawbridge -- --config ./local-config.yml
