#!/bin/sh
WORKDIR="/home/odoo/server"
CONFDIR="/etc/odoo"
LOGDIR="/var/log/odoo"

[ "${AUTOSTART}" = 'True' -a -x "${WORKDIR}"/odoo.py ] || exit 0

if [ -f "${CONFDIR}"/odoo.conf ]; then
	echo "Config file found"
else
	echo "Configuration file not found. Creating it"
	cat > "${CONFDIR}"/odoo.conf <<-EOF
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${PSQL_HOST}
db_port = ${PSQL_PORT}
db_user = ${PSQL_USER}
db_password = ${PSQL_PASSWORD}
xmlrpc_interface = 0.0.0.0
xmlrpc_port = 8069
data_dir = /data
addons_path = /home/odoo/server/addons
; Log settings
syslog = False
log_level = info
EOF

fi

su odoo -c "${WORKDIR}/odoo.py -c ${CONFDIR}/odoo.conf ${CMDLINE_PARAM}" >> "${LOGDIR}"/odoo.log 2>&1

# Script should not exit unless odoo died
while pgrep -f "odoo.py" 2>&1 >/dev/null; do
        sleep 10;
done

exit 1

