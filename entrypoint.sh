#!/bin/bash

# Start PostgreSQL
echo "Initializing PostgreSQL..."
su - postgres -c "/usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data"

echo "Starting PostgreSQL..."
su - postgres -c "/usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -l logfile start"

# Start Redis
echo "Starting Redis..."
redis-server /usr/local/etc/redis/redis.conf --daemonize yes

# Wait for PostgreSQL to be ready
until pg_isready -h localhost -p 5432; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Create the database if it doesn't exist
psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE $POSTGRES_DB"

# Start the Rails server
echo "Starting Rails server..."
bundle exec rails server -b 0.0.0.0
