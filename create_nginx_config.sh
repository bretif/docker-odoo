#!/bin/bash
#set -e

sslBaseDir="/etc/nginx/certs"
sslFullDir="${sslBaseDir}/${DOMAIN_NAME}"
nginxConfFile="${DOMAIN_NAME}.conf"

[ "${autonginx}" = 'true' ] || exit 0
if [ -f /etc/nginx/sites-available/"${nginxConfFile}" ]
then
	echo "Nginx configuration Found, no need to create it"
else
  	cd /etc/nginx/sites-available/
	echo "No Nginx configuration found, Creating it from the template"
	mv /root/nginx.conf ./"${nginxConfFile}"
	mkdir -p $sslFullDir
	export RANDFILE="${sslFullDir}"/.rnd
	openssl genrsa -out "${sslFullDir}"/$DOMAIN_NAME.key 2048
	openssl req -new -x509 -key "${sslFullDir}"/$DOMAIN_NAME.key -out "${sslFullDir}"/$DOMAIN_NAME.crt -days 1825 -subj "/C=FR/ST=France/L=Paris/O=Phosphore/CN=$DOMAIN_NAME" 
	sed -i "s/#ODOO IP#/$ODOO_IP/g" "${nginxConfFile}"
	sed -i "s/#ODOO PORT#/$ODOO_PORT/g" "${nginxConfFile}"
	sed -i "s/#DOMAIN NAME#/$DOMAIN_NAME/g" "${nginxConfFile}"
	sed -i 's|#SSL CERTIFICATE#|'$sslFullDir/$DOMAIN_NAME'.crt|g' "${nginxConfFile}"
	sed -i 's|#SSL KEY#|'$sslFullDir/$DOMAIN_NAME'.key|g' "${nginxConfFile}"
	ln -s /etc/nginx/sites-available/"${nginxConfFile}" /etc/nginx/sites-enabled/"${nginxConfFile}"
fi

