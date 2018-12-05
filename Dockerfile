FROM alpine:latest

LABEL maintainer "Patrick O. S. Kuti <patrick.kuti@px4n.net>"

ARG WALLABAG_VERSION=2.3.4

RUN set -ex \
 && apk update \
 && apk upgrade --available \
 && apk add \
      ansible \
      curl \
      git \
      libwebp \
      pcre \
      php7 \
      php7-amqp \
      php7-bcmath \
      php7-ctype \
      php7-curl \
      php7-dom \
      php7-fpm \
      php7-gd \
      php7-gettext \
      php7-iconv \
      php7-json \
      php7-mbstring \
      php7-openssl \
      php7-pdo_sqlite \
      php7-phar \
      php7-session \
      php7-simplexml \
      php7-tokenizer \
      php7-xml \
      php7-zlib \
      php7-sockets \
      php7-xmlreader \
      py-mysqldb \
      py-psycopg2 \
      py-simplejson \
      s6 \
      tar \
 && rm -rf /var/cache/apk/* \
 && ln -sf /dev/stderr /var/log/php-fpm.log \
 && curl -s https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && git clone --branch $WALLABAG_VERSION --depth 1 https://github.com/wallabag/wallabag.git /var/www/wallabag

COPY root /

RUN set -ex \
 && cd /var/www/wallabag \
 && SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist \
 && chown -R nobody:nobody /var/www/wallabag

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["wallabag"]
