#!/bin/bash

# Update package lists and install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql

# Start the PostgreSQL service
sudo service postgresql start

# Create a PostgreSQL user and database for the Notes application
sudo -u postgres psql -c "CREATE USER cc WITH PASSWORD 'password';"
sudo -u postgres psql -c "CREATE DATABASE devopsdemo;"
sudo -u postgres psql -c "ALTER ROLE cc SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE cc SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE cc SET timezone TO 'UTC';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE devopsdemo TO cc;"

# Configure PostgreSQL to listen on all IP addresses
echo "host all all 192.168.121.221/32 md5" | sudo tee -a /etc/postgresql/$(ls /etc/postgresql)/main/pg_hba.conf
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/$(ls /etc/postgresql)/main/postgresql.conf

# Allow external access to the 'devopsdemo' database from another VM
sudo -u postgres psql -c "ALTER DATABASE devopsdemo CONNECTION LIMIT -1;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE devopsdemo TO cc;"

# Restart PostgreSQL to apply the changes
sudo service postgresql restart

# Print PostgreSQL version and status
sudo -u postgres psql -c "SELECT version();"
sudo service postgresql status