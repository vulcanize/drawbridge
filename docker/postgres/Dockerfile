FROM golang:1.10-alpine3.7 AS builder

MAINTAINER Alex Kawas <vulcanize.io>

ENV VERSION v3.2.0

RUN apk add --no-cache git

RUN go get -v -d github.com/golang-migrate/migrate/cli \
    && go get -v -d github.com/lib/pq

WORKDIR /go/src/github.com/golang-migrate/migrate

RUN git checkout ${VERSION} \
    && CGO_ENABLED=0 go build -tags 'postgres' -o ./bin/migrate -ldflags '-extldflags "-static"' ./cli

FROM postgres:9.4 as final

# Set working directory
WORKDIR /docker-entrypoint-initdb.d

EXPOSE 5432

COPY --from=builder /go/src/github.com/golang-migrate/migrate/bin/migrate /usr/local/bin/migrate

# Install migrations
COPY migrations/*.up.sql /migrations/

# scripts should be auto-run by init scripts
COPY 001_setup-database.sh .
RUN chmod +x 001_setup-database.sh

COPY 002_migrate-database.sh .
RUN chmod +x 002_migrate-database.sh
