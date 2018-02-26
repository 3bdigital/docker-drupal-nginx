FROM php:5.6-fpm

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
RUN yes | pecl install redis-2.2.5 memcache-3.0.8 xdebug \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
	&& echo "extension=memcache.so" > /usr/local/etc/php/conf.d/memcache.ini \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \ 
	&& echo "xdebug.max_nesting_level=500" >> /usr/local/etc/php/conf.d/xdebug.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get update && apt-get -y install mysql-client

# blackfire setup
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /usr/local/etc/php/conf.d/blackfire.ini

WORKDIR /root
# Install Drush 5 (legacy, can probably be removed)
RUN curl -L -O https://github.com/drush-ops/drush/archive/5.11.0.tar.gz \
	&& tar -xzf 5.11.0.tar.gz \
	&& chmod u+x /root/drush-5.11.0/drush \
	&& ln -s /root/drush-5.11.0/drush /usr/bin/drush5

# Install Drush 8
# If the .phar becomes unavailable this could be installed using Composer
# e.g. RUN composer global require drush/drush:"$DRUSH_VERSION" --prefer-dist
RUN curl -OL https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar \
	&& chmod +x drush.phar \
	&& mv drush.phar /usr/local/bin/drush
	
# new relic
RUN curl https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN sh -c 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list'

RUN apt-get update && apt-get install -y newrelic-php5
ENV NR_INSTALL_SILENT true
ENV NR_INSTALL_PATH /usr/local/bin;
RUN newrelic-install install
	
EXPOSE 80 443

COPY ssl/dev.3bweb.com.crt /etc/nginx/ssl/dev.3bweb.com.crt
COPY ssl/dev.3bweb.com.key /etc/nginx/ssl/dev.3bweb.com.key

# drupal config for nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY drupal.conf /etc/nginx/conf.d/default.conf

# drupal config for php
COPY opcache-recommended.ini drupal.ini /usr/local/etc/php/conf.d/

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD php-fpm -D && nginx -g 'daemon off;'