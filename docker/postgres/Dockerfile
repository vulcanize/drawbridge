FROM postgres:9.4 as final
  
MAINTAINER Alex Kawas <vulcanize.io>

# Set working directory
WORKDIR /docker-entrypoint-initdb.d

EXPOSE 5432

# Install migrations
COPY migrations/*.up.sql ./

# migrations should be auto-run by init scripts
