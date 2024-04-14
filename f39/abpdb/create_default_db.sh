
#!/bin/bash

export PGPASSWORD=root123

# PostgreSQL 접속 정보
PG_USER="foreman"
PG_HOST="abpdb.example.com"
PG_PORT=5432

# Modify PostgreSQL Config
sed -i s/'127.0.0.1\/32'/'0.0.0.0\/0'/ /var/lib/postgresql/data/pgdata/pg_hba.conf
sleep 1

# reload with the above config 
pg_ctl restart -D /var/lib/postgresql/data/pgdata
sleep 10

echo DEBUG -----------------

# Function to check if PostgreSQL is ready
wait_for_postgres() {
    until psql -U "$PG_USER" -p "$PG_PORT" -c '\q' &> /dev/null; do
        echo "Waiting for PostgreSQL to be available..."
        sleep 5
        psql -U "$PG_USER" -p "$PG_PORT" -c '\l'
    done
    echo "PostgreSQL is now available."
}

# Wait for PostgreSQL
wait_for_postgres


# 1. Create a User (abp)
psql -U $PG_USER -p $PG_PORT -w -c "CREATE USER abp WITH ENCRYPTED PASSWORD 'abp';"
sleep 1
psql -U $PG_USER -p $PG_PORT -w -c "CREATE USER temporal WITH ENCRYPTED PASSWORD 'temporal';"

# 2. Create a Password for a User (abp)
psql -U $PG_USER -p $PG_PORT -w -c "ALTER ROLE abp WITH PASSWORD 'abp';"
sleep 1
psql -U $PG_USER -p $PG_PORT -w -c "ALTER ROLE abp WITH PASSWORD 'temporal';"

# 3. Set a Grant(ex: superuser)
psql -U $PG_USER -p $PG_PORT -w -c "ALTER USER abp WITH SUPERUSER CREATEDB CREATEROLE REPLICATION BYPASSRLS;"
sleep 1
psql -U $PG_USER -p $PG_PORT -w -c "ALTER USER temporal WITH SUPERUSER CREATEDB CREATEROLE REPLICATION BYPASSRLS;"

# 4. Extra Databases
psql -U $PG_USER -p $PG_PORT -w -c "CREATE DATABASE abp;"
psql -U $PG_USER -p $PG_PORT -w -c "CREATE DATABASE \"abp-log\";"
psql -U $PG_USER -p $PG_PORT -w -c "CREATE DATABASE \"candlepin\";"
psql -U $PG_USER -p $PG_PORT -w -c "CREATE DATABASE \"pulpcore\";"
psql -U $PG_USER -p $PG_PORT -w -c "CREATE DATABASE \"temporal\";"

