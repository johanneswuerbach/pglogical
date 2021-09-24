FROM debian:buster-slim

# Install pglogical build dependencies
RUN apt-get update && \
  apt-get install -y make libedit-dev libxml2-dev zlib1g-dev g++ libssl-dev libkrb5-dev libxslt1-dev libpam0g-dev libselinux1-dev wget gnupg2 && \
  rm -rf /var/lib/apt/lists/*

# Install old postgres version
RUN echo "deb http://apt-archive.postgresql.org/pub/repos/apt buster-pgdg-archive main" > /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && \
  apt-get install -y postgresql-11=11.7-3.pgdg100+1 postgresql-server-dev-11=11.7-3.pgdg100+1 postgresql-client-11=11.7-3.pgdg100+1 && \
  rm -rf /var/lib/apt/lists/*
