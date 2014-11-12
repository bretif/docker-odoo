#!/bin/sh
WORKINGDIR="/home/odoo/server"
[ "${AUTOSTART}" = 'True' -a -x "${WORKINGDIR}"/odoo.py ] || exit 0

su odoo -c "${WORKINGDIR}/odoo.py -c ${WORKINGDIR} ${CMDLINE_PARAM}" >> "${WORKINGDIR}"/odoo.log 2>&1

# Script should not exit unless seafile died
while pgrep -f "odoo.py" 2>&1 >/dev/null; do
        sleep 10;
done

exit 1

