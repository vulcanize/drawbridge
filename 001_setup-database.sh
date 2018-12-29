#!/usr/bin/env bash


# non-essential for docker setup, and only occasionally for local setup
PSQL=(`which psql`)
PGEXISTS=(`$PSQL -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'"`)
if [ ! $PGEXISTS ]; then
  echo "Creating postgres user..."
  createuser postgres
else
  echo "Database user found: postgres"
fi

# non-essential for docker setup; essential for local setup
DBEXISTS=(`$PSQL -U postgres -lqt | cut -d \| -f 1 | grep -w drawbridge | sed -e 's/^[ \t]*//'`)
if [ -z $DBEXISTS ]; then
  echo "Creating drawbridge database..."
  createdb -U postgres drawbridge
else
  echo "Database found: drawbridge"
fi

# essential for both docker and local setup
DBEXISTS=(`$PSQL -U postgres -lqt | cut -d \| -f 1 | grep -w drawbridge_2 | sed -e 's/^[ \t]*//'`)
if [ -z $DBEXISTS ]; then
  echo "Creating drawbridge_2 database..."
  createdb -U postgres drawbridge_2
else
  echo "Database found: drawbridge_2"
fi
