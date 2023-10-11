#!/bin/bash

# Update and install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql-14

# Start the PostgreSQL service
sudo service postgresql start

# Create a new PostgreSQL user and database
sudo -u postgres psql -c "CREATE USER cc WITH PASSWORD 'password';"
sudo -u postgres psql -c "ALTER ROLE cc SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE cc SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE cc SET timezone TO 'UTC';"
sudo -u postgres psql -c "CREATE DATABASE devops OWNER cc;"

# Grant all privileges to the user on the database
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE devops TO cc;"

# Configure PostgreSQL to allow connections from the backend VM
echo "host    all             all             192.168.121.221/32        md5" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/14/main/postgresql.conf

# Restart PostgreSQL for changes to take effect
sudo service postgresql restart

# Print PostgreSQL version and status
sudo -u postgres psql -c "SELECT version();"
sudo service postgresql status