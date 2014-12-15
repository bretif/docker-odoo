#!/bin/sh

set -e

PSQL_PASS=${PSQL_PASS:-$(pwgen -s -1 16)}
CONF_FILENAME="odoo.conf"

# Create config file if it doesn't exist
if [ ! -f "${CONF_DIR}/${CONF_FILENAME}" ] && [ "${autoconf}" = 'true' ]
then
	echo "Configuration file not found. Creating it"
	cat > "${CONF_DIR}/${CONF_FILENAME}" <<-EOF
[options]
admin_passwd = ${ADMIN_PASS}
db_host = ${PSQL_HOST}
db_port = ${PSQL_PORT}
db_user = ${PSQL_USER}
db_password = ${PSQL_PASS}
xmlrpc_interface = 0.0.0.0
xmlrpc_port = ${ODOO_PORT}
data_dir = ${DATA_DIR}
addons_path = ${BIN_DIR}/addons
; Log settings
syslog = False
logfile = ${LOG_DIR}/odoo.log
log_level = info
EOF

	# Create user in postgres if root pass is specified
	if [ -n $PSQL_ROOT_USER -a -n $PSQL_ROOT_PASS ]
		then 
		echo "${PSQL_HOST}:${PSQL_PORT}:postgres:${PSQL_ROOT_USER}:${PSQL_ROOT_PASS}" > /root/.pgpass
		chmod 600 /root/.pgpass
		createuser -h ${PSQL_HOST} --createdb --no-createrole --no-superuser ${PSQL_USER}
		psql --command "ALTER USER ${PSQL_USER} WITH PASSWORD '${PSQL_PASS}';" -h ${PSQL_HOST} -d postgres
	fi
fi


[ "${autostart}" = 'true' ] || exit 0

#Run odoo  process
exec /sbin/setuser ${ODOO_USER} ${BIN_DIR}/odoo.py -c ${CONF_DIR}/${CONF_FILENAME} ${CMDLINE_PARAM}


