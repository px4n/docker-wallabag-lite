# What is wallabag?

[![Build Status](https://travis-ci.org/wallabag/docker.svg?branch=master)](https://travis-ci.org/px4n/docker-wallabag-lite)

[wallabag](https://www.wallabag.org/) is a self hostable application for saving web pages. Unlike other services, wallabag is free (as in freedom) and open source.

With this application you will not miss content anymore. Click, save, read it when you want. It saves the content you select so that you can read it when you have time.

THIS IMAGE IS STILL VERY MUCH BROKEN AND VERY MUCH UNDER TESTING.

# How to use this image

Default login is `wallabag:wallabag`.

## Purpose of this image

The purpose of this image is to be a light stand-alone PHP only version of wallabag, that cane be proxied to from other docker containers or external web installations.
It is very much a work-in-progress, so pleae use at your own discretion.

## Environment variables

- `-e MYSQL_ROOT_PASSWORD=...` (needed for the mariadb container to initialise and for the entrypoint in the wallabag container to create a database and user if its not there)
- `-e POSTGRES_PASSWORD=...` (needed for the posgres container to initialise and for the entrypoint in the wallabag container to create a database and user if not there)
- `-e POSTGRES_USER=...` (needed for the posgres container to initialise and for the entrypoint in the wallabag container to create a database and user if not there)
- `-e SYMFONY__ENV__DATABASE_DRIVER=...` (defaults to "pdo_sqlite", this sets the database driver to use)
- `-e SYMFONY__ENV__DATABASE_DRIVER_CLASS=...` (sets the database driver class to use)
- `-e SYMFONY__ENV__DATABASE_HOST=...` (defaults to "127.0.0.1", if use mysql this should be the name of the mariadb container)
- `-e SYMFONY__ENV__DATABASE_PORT=...` (port of the database host)
- `-e SYMFONY__ENV__DATABASE_NAME=...`(defaults to "symfony", this is the name of the database to use)
- `-e SYMFONY__ENV__DATABASE_USER=...` (defaults to "root", this is the name of the database user to use)
- `-e SYMFONY__ENV__DATABASE_PASSWORD=...` (defaults to "~", this is the password of the database user to use)
- `-e SYMFONY__ENV__DATABASE_CHARSET=...` (defaults to utf8, this is the database charset to use)
- `-e SYMFONY__ENV__SECRET=...` (defaults to "ovmpmAWXRCabNlMgzlzFXDYmCFfzGv")
- `-e SYMFONY__ENV__MAILER_HOST=...`  (defaults to "127.0.0.1", the SMTP host)
- `-e SYMFONY__ENV__MAILER_USER=...` (defaults to "~", the SMTP user)
- `-e SYMFONY__ENV__MAILER_PASSWORD=...`(defaults to "~", the SMTP password)
- `-e SYMFONY__ENV__FROM_EMAIL=...`(defaults to "wallabag@example.com", the address wallabag uses for outgoing emails)
- `-e SYMFONY__ENV__FOSUSER_REGISTRATION=...`(defaults to "true", enable or disable public user registration)
- `-e SYMFONY__ENV__FOSUSER_CONFIRMATION=...`(defaults to "true", enable or disable registration confirmation)
- `-e SYMFONY__ENV__DOMAIN_NAME=...`  defaults to "https://your-wallabag-url-instance.com", the URL of your wallabag instance)
- `-e POPULATE_DATABASE=...`(defaults to "True". Does the DB has to be populated or is it an existing one)

## SQLite

The easiest way to start wallabag is to use the SQLite backend. You can spin that up with

```
$ docker run -p px4n/wallabag-lite
```

and point your browser to `http://localhost:9000`. For persistent storage you should start the container with a volume:

```
$ docker run -v /opt/wallabag/data:/var/www/wallabag/data -v /opt/wallabag/images:/var/www/wallabag/web/assets/images -p 80:80 wallabag/wallabag
```


```

## Upgrading

You can start the container with the new image and run the migration command manually:

```
$ docker exec -t NAME_OR_ID_OF_YOUR_WALLABAG_CONTAINER /var/www/wallabag/bin/console doctrine:migrations:migrate --env=prod --no-interaction
```

## docker-compose

It's a good way to use [docker-compose](https://docs.docker.com/compose/). Example:

```
version: "3.5"

networks:
  docker_nginx_default:
    name: docker_nginx_default

volumes:
  wallabag_data:
    driver: local

services:
  wallabag:
    image: wallabag/wallabag:latest
    container_name: wallabag
    restart: always
    environment:
      - SYMFONY__ENV__MAILER_HOST=127.0.0.1
      - SYMFONY__ENV__MAILER_USER=~
      - SYMFONY__ENV__MAILER_PASSWORD=~
      - SYMFONY__ENV__FROM_EMAIL=wallabag@example.com
    networks:
      - docker_nginx_default
    volumes:
      - wallabag_data:/var/www/wallabag/data
```

Note that you must fill out the mail related variables according to your mail config.
