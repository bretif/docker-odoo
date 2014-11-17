FROM        phusion/baseimage:0.9.15
MAINTAINER  Bertrand RETIF  <bretif@sudokeys.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python-pip python-dev build-essential libpq-dev \
    poppler-utils antiword libldap2-dev libsasl2-dev libssl-dev git \
    python-dateutil python-feedparser python-gdata python-ldap python-lxml \
    python-mako python-openid python-psycopg2 python-pychart python-pydot \
    python-pyparsing python-reportlab python-tz python-vatnumber python-vobject \
    python-webdav python-xlwt python-yaml python-zsi python-docutils python-unittest2 \
    python-mock python-jinja2 libevent-dev libxslt1-dev libfreetype6-dev libjpeg8-dev \
    python-werkzeug libjpeg-dev build-essential python-svn python-simplejson \
    python-babel python-decorator python-psutil python-pypdf \
    wget

RUN pip install passlib

# install wkhtmltopdf
RUN wget https://s3.amazonaws.com/akretion/packages/wkhtmltox-0.12.1_linux-trusty-amd64.deb && \
    dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb && rm wkhtmltox-0.12.1_linux-trusty-amd64.deb

ENV AUTOSTART True
ENV ADMIN_PASSWORD odooadmin
ENV PSQL_HOST odoo-database
ENV PSQL_PORT 5432
ENV PSQL_USER odoo
ENV PSQL_PASSWORD odoopass


RUN useradd -d /home/odoo -m odoo
RUN git clone -b8.0 https://github.com/odoo/odoo.git /home/odoo/server
RUN chown -R odoo /home/odoo

# Odoo conf
RUN mkdir /etc/odoo
RUN chown -R odoo /etc/odoo

# Odoo daemon
RUN mkdir /etc/service/odoo
ADD run_odoo.sh /etc/service/odoo/run
RUN chmod +x /etc/service/odoo/run
# Expose the odoo port
EXPOSE 8069

VOLUME  ["/etc/odoo", "/var/log/", "/home/odoo"]

CMD ["/sbin/my_init"]

# Add my public keys
ADD pubkeys /tmp/pubkeys
RUN cat /tmp/pubkeys/*.pub >> /root/.ssh/authorized_keys && rm -rf /tmp/pubkeys/
EXPOSE 22

# Clean up for smaller image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

