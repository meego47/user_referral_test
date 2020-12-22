FROM nginx:1.14.2-alpine

ARG UID=1000
ARG GID=1000

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "@php https://dl.bintray.com/php-alpine/v3.9/php-7.4" >> /etc/apk/repositories
RUN apk add --no-cache --update \
    ca-certificates openssl \
    php@php \
    php-common@php \
    php-ctype@php \
    php-curl@php \
    php-fpm@php \
    php-gd@php \
    php-intl@php \
    php-json@php \
    php-mbstring@php \
    php-openssl@php \
    php-pdo@php \
    php-pdo_mysql@php \
    php-mysqlnd@php \
    php-xml@php \
    php-zip@php \
    php-redis@php \
  #  php7-memcached@php=3.1.4-r1 \
    php-phar@php \
    php-pcntl@php \
    php-dom@php \
    php-posix@php \
    php-imagick@php \
    php-xdebug@php \
    php-iconv@php\
    php-xmlreader@php\
    php-zlib@php\
    bash git grep dcron tzdata su-exec shadow \
    supervisor

# Sync user and group with the host
RUN usermod -u ${UID} nginx && groupmod -g ${GID} nginx

# Configure time
RUN echo "Europe/Chisinau" > /etc/timezone && \
    cp /usr/share/zoneinfo/Europe/Chisinau /etc/localtime && \
    apk del --no-cache tzdata && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

WORKDIR /var/www/html/

COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

RUN mkdir -p /var/www/html && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/lib/nginx && \
    chown -R nginx:nginx /var/cache/nginx /var/lib/nginx && \
    chmod -R g+rw /var/cache/nginx /var/lib/nginx /etc/php7/php-fpm.d && \
    ln -s /usr/bin/php7 /usr/bin/php

COPY docker/conf/php-fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY docker/conf/supervisord.conf /etc/supervisor/supervisord.conf
COPY docker/conf/nginx.conf /etc/nginx/nginx.conf
COPY docker/conf/nginx-site.conf /etc/nginx/conf.d/default.conf
COPY docker/conf/php.ini /etc/php7/conf.d/50-settings.ini
COPY docker/entrypoint.sh /sbin/entrypoint.sh

COPY --chown=nginx:nginx ./ .

#VOLUME /var/www/html/storage

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["true"]
