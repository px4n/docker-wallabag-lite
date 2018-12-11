# What is wallabag-lite?

[![Build Status](https://travis-ci.org/px4n/docker-wallabag-lite.svg?branch=master)](https://travis-ci.org/px4n/docker-wallabag-lite) [![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/px4n/docker-wallabag-lite.svg)](https://isitmaintained.com/project/px4n/docker-wallabag-lite "Average time to resolve an issue") [![Percentage of issues still open](https://isitmaintained.com/badge/open/px4n/docker-wallabag-lite.svg)](https://isitmaintained.com/project/px4n/docker-wallabag-lite "Percentage of issues still open") 

wallabag-lite is a docker image of [wallabag](https://www.wallabag.org/) that aims to be simple and light.

# How to use this image

## Purpose of this image

The purpose of this image is to be as alternative lightweight version of the original [wallabag docker image](https://github.com/wallabag/docker). 

It aims to be as simple as possible and comes with a set of sane defaults while assuming that the user will have an edge HTTPS web server already setup and proxying to this image.

Used dependeinces are: Nginx, PHP, and Sqlite.

## Default login credentials 

The default login for this image is  `username: wallabag, password: wallabag`.

## Configurable environment variables

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

## Installation with docker run

The easiest way to start using wallabag-lite is do a docker run, as below:

```
$ docker run -p 1314:80 px4n/wallabag-lite
```

and point your browser to `http://localhost:1314`.

For persistent storage you should start the container with a set of volumes:

```
$ docker run \
-v <HOST_VOLUME_PATH_FOR_WALLABAG_DATA>:/var/www/wallabag/data \
-v <HOST_VOLUME_PATH_FOR_WALLABAG_IMAGES>:/var/www/wallabag/web/assets/images \
-p 80:80 px4n/wallabag-lite
```

## Installation with docker-compose

It's a good way to use [docker-compose](https://docs.docker.com/compose/). Example:

```
version: "3.5"

volumes:
  wallabag_data:
    driver: local
volumes:
  wallabag_images:
    driver: local

services:
  wallabag:
    image: px4n/wallabag-lite:latest
    container_name: wallabag
    restart: always
    environment:
      - SYMFONY__ENV__SECRET=Y36pscsOIRzyb61DxRqf8OH0
      - SYMFONY__ENV__MAILER_HOST=127.0.0.1:25
      - SYMFONY__ENV__MAILER_USER=~
      - SYMFONY__ENV__MAILER_PASSWORD=~
      - SYMFONY__ENV__FROM_EMAIL=no-reply@wallabag.org
      - SYMFONY__ENV__FOSUSER_REGISTRATION=false
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__DOMAIN_NAME=https://localhost:1314
    volumes:
      - wallabag_data:/var/www/wallabag/data
      - wallabag_images:/var/www/wallabag/web/assets/images

```

_Note that you must fill out the above environment variables according to your desired setup._

## Upgrading

After pulling the latest docker image from docker hub, you can execute the migration command manually within the container as so:

```
$ docker exec \
-t NAME_OR_ID_OF_YOUR_WALLABAG_CONTAINER /var/www/wallabag/bin/console doctrine:migrations:migrate --env=prod --no-interaction
```