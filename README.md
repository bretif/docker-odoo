# docker-odoo
===========

[Odoo](https://www.odoo.com/) 8 docker container

## Postgressql db

run a postgres container like this :

    docker run --name mypostgres -d bretif/postgres

postgres autocreate a root user and write the password to docker logs

## Start an odoo container
You need to specify PSQL_ROOT_PASS for odoo to create a user automatically with randomly generated password or PSQL_USER and PSQL_PASS to use an existing user able to create databases

    docker run --name myodoo -d --link mydb:odoo-database -p 80:8069 -e "PSQL_ROOT_PASS=yourpass" bretif/odoo

## Configure nginx
Example with nginx autoconfiguration
    docker run -d --name myodoo --volumes-from nginx -p 8069:8069 -e "ADMIN_PASS=myadminpass" \
        -e "PSQL_ROOT_PASS=yourpass" -e "DOMAIN_NAME=mydomain" -e "ODOO_IP=container.XXX" \
        -e "ODOO_PORT=869" bretif/odoo


### All startup options configuration
Here are the following environments variables and their default values that you can modify when running the container :


    autostart                 true
    autoconf                  true
    autonginx                 true
    ADMIN_PASS                odooadmin    
    PSQL_HOST                 odoo-database
    PSQL_PORT                 5432
    PSQL_USER                 odoo
    PSQL_ROOT_USER            root
    PSQL_ROOT_PASS            None : need to be filled if you want odoo to auto-create the postgres user
    PSQL_PASS                 randomly generated if not specified
    DOMAIN_NAME     Domain configured in Nginx container
    ODOO_IP         Name or IP of the container used in nginx vhost. Must be resolved by nginx.
    ODOO_PORT       Odoo port used in nginx configuration.



