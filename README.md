# docker-odoo
===========

[Odoo](https://www.odoo.com/) 8 docker container

## Postgressql db
build and start the postgresql container according to the [postgres Readme](https://github.com/Guilhem30/docker-postgresql)
To create a postgre user for odoo you can run from inside the progres container :

   su - postgres
   createuser --createdb --username postgres --no-createrole --no-superuser --pwprompt odoo8
 
##Build odoo container
You can modify the odoo.conf file according to your postgre user.

Then build the odoo container with

    docker build -t your_image_name:your_version .

Example

    docker build -t odoo:v1 .

## Start an odoo container with odoo auto-starting
Once your postgre container is running and ready with your odoo user you can run an odoo container as a daemon 

    docker run --name your_instance_name -d --link your_postgres_container_name:odoo-database -p your_port_number:8069 your_image_name:your_version

Example 

    docker run --name myodoo -d --link mydb:odoo-database -p 80:8069 odoo:v1

## Run the container with a shell
If your postgres container isn't ready yet or you just want to look around with a shell

    docker run --name myodoo -t -i odoo:v1 /bin/bash

images are build from [`phusion/baseimage`](https://github.com/phusion/baseimage-docker), you can connect to them through ssh if you expose port 22.
my dockerfile include all public keys stored in pubkeys dir.

You can also just use docker exec to run a bash process in an existing container

    docker exec -t -i container_name bash


