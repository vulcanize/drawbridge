#!/usr/bin/env bash
/usr/local/bin/migrate -database "postgres://postgres@/drawbridge?host=/var/run/postgresql/&sslmode=disable" -path /migrations up
/usr/local/bin/migrate -database "postgres://postgres@/drawbridge_2?host=/var/run/postgresql/&sslmode=disable" -path /migrations up
