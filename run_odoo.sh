#!/bin/sh

[ "${AUTOSTART}" = 'True' -a -x /home/odoo/server/odoo.py ] || exit 0

/home/odoo/server/odoo.py -c ./odoo.conf >> /home/odoo/server/odoo.log 2>&1

# Script should not exit unless seafile died
while pgrep -f "odoo.py" 2>&1 >/dev/null; do
        sleep 10;
done

exit 1

