ARG ALPINE_VERSION=3.16
FROM alpine:${ALPINE_VERSION}
LABEL Description="Nginx 1.22 & PHP 8.1 based on Alpine Linux."
WORKDIR /var/www/html

RUN apk add --no-cache \
  curl \
  nginx \
  php81 \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-fpm \
  php81-gd \
  php81-intl \
  php81-mbstring \
  php81-mysqli \
  php81-opcache \
  php81-openssl \
  php81-phar \
  php81-session \
  php81-xml \
  php81-xmlreader \
  php81-pdo \
  php81-pdo_sqlite \
  php81-sqlite3 \
  php81-tokenizer \
  php81-pgsql \
  php81-pdo_pgsql \
  supervisor

RUN ln -s /usr/bin/php81 /usr/bin/php

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php.ini /etc/php81/conf.d/custom.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx

ENV APP_ENV prod

USER nobody

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping