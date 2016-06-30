#!/bin/bash

PG_HOME="/var/lib/postgresql"
PG_DATADIR="${PG_HOME}/${PG_VERSION}/main"
PG_BIN="/usr/lib/postgresql/${PG_VERSION}/bin"
PG_CONFIG="/etc/postgresql/${PG_VERSION}/main"

if [ "$1" = 'postgres' ]; then

	# Locale config
	# echo "Configuring locale..."
	# echo "en_HK.UTF8 UTF-8" >> /etc/locale.gen
	# echo `locale-gen`
	# echo "Done"


	# Create directory
	mkdir -p -m 0700 "$PG_HOME"
	# Set owner and group
	chown -R postgres:postgres "$PG_HOME"

	# Set /run/postgresql
	mkdir -p -m 0755 /run/postgresql /run/postgresql/${PG_VERSION}-main.pg_stat_tmp
	chown -R postgres:postgres /run/postgresql
	chmod g+s /run/postgresql

	# Listen on all interface
	echo "listen_addresses = '*'" >> ${PG_CONFIG}/postgresql.conf
	# Allow remote connections
	echo "host all all 192.168.1.0/24 md5" >> ${PG_CONFIG}/pg_hba.conf

	# Initialize PostgreSQL data directory
	if [ ! -d ${PG_DATADIR} ]; then 
		# Init User
		PG_USER=${PG_USER:='ofbiz'}
		PG_PASSWORD=${PG_PASSWORD:='123456'}

		echo "Initializing database..."
		sudo -u postgres -H "$PG_BIN/initdb" --pgdata="$PG_DATADIR" --encoding=UTF8 > /dev/null

		# Create user
		echo "Creating User $PG_USER with password $PG_PASSWORD"
		# "$PG_BIN/psql" --command "CREATE USER ${PG_USER} WITH LOGIN SUPERUSER PASSWORD '${PG_PASSWORD}';"
		echo "CREATE USER ${PG_USER} WITH SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN PASSWORD '${PG_PASSWORD}';" |
		      sudo -u postgres -H ${PG_BIN}/postgres --single \
			-D ${PG_DATADIR} -c config_file=${PG_CONFIG}/postgresql.conf >/dev/null
	fi

	echo "Starting postgresql..."
	exec sudo -u postgres -H ${PG_BIN}/postgres -D ${PG_DATADIR} -c config_file=${PG_CONFIG}/postgresql.conf
fi
