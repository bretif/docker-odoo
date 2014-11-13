#!/bin/sh
WORKDIR="/home/odoo/server"
CONFDIR="/etc/odoo"
LOGDIR="/var/log"

[ "${AUTOSTART}" = 'True' -a -x "${WORKDIR}"/odoo.py ] || exit 0

su odoo -c "${WORKDIR}/odoo.py -c ${CONFDIR}/odoo.conf ${CMDLINE_PARAM}" >> "${LOGDIR}"/odoo.log 2>&1

# Script should not exit unless seafile died
while pgrep -f "odoo.py" 2>&1 >/dev/null; do
        sleep 10;
done

exit 1

