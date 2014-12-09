#!/bin/sh
CONF_FILENAME="odoo.conf"

if [ -f "${CONF_DIR}/${CONF_FILENAME}" ];
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

fi

exec /sbin/setuser ${ODOO_USER} ${BIN_DIR}/odoo.py -c ${CONF_DIR}/${CONF_FILENAME} ${CMDLINE_PARAM}


