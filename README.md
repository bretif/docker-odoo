# docker-odoo
===========

[Odoo](https://www.odoo.com/) 8 docker container

## Postgressql db
You need to use a postgresql container
To be filled....

## Start odoo container
You can use parameter start you container. You just have to put correct parameters.

    docker run -t -i -p 3333:8069 \
      -e AUTOSTART=True
      -e ENV ADMIN_PASSWORD=odooadmin
      -e PSQL_HOST=db
      -e ENV PSQL_PORT=5432
      -e ENV PSQL_USER=odoo
      -e PSQL_PASSWORD=odoopass
      bretif/docker-odoo


If you want to start a shell, you can start with `-- /bin/bash` as parameter.
The image builds on [`phusion/baseimage`](https://github.com/phusion/baseimage-docker), you then can connect to it through ssh.
In my dockerfile in include all public keys stored in pubkeys dir.

    docker run -t -i -p 3333:8069 bretif/docker-odoo:v2 -- /bin/bash
