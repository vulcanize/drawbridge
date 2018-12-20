#!/usr/bin/env bash

PSQL=(`which psql`)
PGEXISTS=(`$PSQL postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'"`)
if [ ! PGEXISTS ]; then
  echo "Creating postgres user..."
  createuser postgres
else
  echo "Database user found: postgres"
fi

DBEXISTS=(`$PSQL -lqt | cut -d \| -f 1 | grep -qw drawbridge_2`)

if [ ! DBEXISTS ]; then
  echo "Creating drawbridge_2 database..."
  createdb drawbridge_2
else
  echo "Database found: drawbridge_2"
fi
