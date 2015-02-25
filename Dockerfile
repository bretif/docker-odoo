FROM        guilhem30/sudokeys
MAINTAINER  Guilhem Berna  <guilhem.berna@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -yq python-pip python-dev build-essential libpq-dev \
    poppler-utils antiword libldap2-dev libsasl2-dev libssl-dev git \
    python-dateutil python-feedparser python-gdata python-ldap python-lxml \
    python-mako python-openid python-psycopg2 python-pychart python-pydot \
    python-pyparsing python-reportlab python-tz python-vatnumber python-vobject \
    python-webdav python-xlwt python-yaml python-zsi python-docutils python-unittest2 \
    python-mock python-jinja2 libevent-dev libxslt1-dev libfreetype6-dev libjpeg8-dev \
    python-werkzeug libjpeg-dev build-essential python-svn python-simplejson \
    python-babel python-decorator python-psutil python-pypdf wget rsync postgresql-client-9.3 pwgen && \
    pip install passlib 

# install wkhtmltopdf
RUN wget https://s3.amazonaws.com/akretion/packages/wkhtmltox-0.12.1_linux-trusty-amd64.deb && \
    dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb && rm wkhtmltox-0.12.1_linux-trusty-amd64.deb

ENV autostart true
ENV autoconf true
ENV autonginx true
ENV ADMIN_PASS odooadmin
ENV PSQL_HOST odoo-database
ENV PSQL_PORT 5432
ENV PSQL_USER odoo
ENV PSQL_ROOT_USER root
ENV DOMAIN_NAME odoo.sudokeys.com
#Should not be changed at run time
ENV ODOO_USER odoo
ENV ODOO_PORT 8069
ENV ODOO_IP 127.0.0.1
ENV BIN_DIR /home/${ODOO_USER}/server
ENV CONF_DIR /etc/odoo
ENV LOG_DIR /var/log/odoo
ENV DATA_DIR /data

RUN useradd -d /home/${ODOO_USER} -m ${ODOO_USER}
RUN git clone -b8.0 https://github.com/odoo/odoo.git ${BIN_DIR}
RUN chown -R ${ODOO_USER} ${BIN_DIR}

# Odoo conf
RUN mkdir ${CONF_DIR}
RUN chown -R ${ODOO_USER} ${CONF_DIR}

# Odoo data
RUN mkdir ${DATA_DIR}
RUN chown -R ${ODOO_USER} ${DATA_DIR}

# Odoo log
RUN mkdir ${LOG_DIR}
RUN chown -R ${ODOO_USER} ${LOG_DIR}

# Odoo daemon
RUN mkdir /etc/service/odoo
COPY run_odoo.sh /etc/service/odoo/run
RUN chmod +x /etc/service/odoo/run

# Nginx autoconfiguration
COPY create_nginx_config.sh /etc/my_init.d/create_nginx_config.sh
COPY nginx.conf /root/nginx.conf

# Expose the odoo port
EXPOSE 8069

VOLUME  ["${CONF_DIR}", "${LOG_DIR}", "${DATA_DIR}"]

CMD ["/sbin/my_init"]

# Clean up for smaller image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

