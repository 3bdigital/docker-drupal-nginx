FROM php:5.5-fpm

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip

VOLUME /var/www/html

ENV NGINX_VERSION 1.9.11-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*
	
# xdebug & redis
RUN yes | pecl install redis-2.2.5 xdebug \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \ 
	&& echo "xdebug.max_nesting_level=500" >> /usr/local/etc/php/conf.d/xdebug.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
	
# drupal config for nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY drupal.conf /etc/nginx/conf.d/default.conf

# drupal config for php
COPY opcache-recommended.ini drupal.ini /usr/local/etc/php/conf.d/
	
EXPOSE 80 443

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD php-fpm -D && nginx -g 'daemon off;'