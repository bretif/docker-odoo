#!/bin/sh

set -e

PSQL_PASSWORD=${PSQL_PASSWORD:-$(pwgen -s -1 16)}
CONF_FILENAME="odoo.conf"

# Create config file if it doesn't exist
if [ -f "${CONF_DIR}/${CONF_FILENAME}" ]
then
	echo "Config file found"
else
	echo "Configuration file not found. Creating it"
	cat > "${CONF_DIR}/${CONF_FILENAME}" <<-EOF
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${PSQL_HOST}
db_port = ${PSQL_PORT}
db_user = ${PSQL_USER}
db_password = ${PSQL_PASSWORD}
xmlrpc_interface = 0.0.0.0
xmlrpc_port = 8069
data_dir = ${DATA_DIR}
addons_path = ${BIN_DIR}/addons
; Log settings
syslog = False
logfile = ${LOG_DIR}/odoo.log
log_level = info
EOF

	# Create user in postgres if root pass is specified
	if [ -n $PSQL_ROOT_USER -a -n $PSQL_ROOT_PASSWORD ]
		then 
		echo "${PSQL_HOST}:${PSQL_PORT}:postgres:${PSQL_ROOT_USER}:${PSQL_ROOT_PASSWORD}" > /root/.pgpass
		chmod 600 /root/.pgpass
		createuser -h ${PSQL_HOST} --createdb --no-createrole --no-superuser ${PSQL_USER}
		psql --command "ALTER USER ${PSQL_USER} WITH PASSWORD '${PSQL_PASSWORD}';" -h ${PSQL_HOST} -d postgres
	fi
fi

#Run odoo  process
exec /sbin/setuser ${ODOO_USER} ${BIN_DIR}/odoo.py -c ${CONF_DIR}/${CONF_FILENAME} ${CMDLINE_PARAM}


