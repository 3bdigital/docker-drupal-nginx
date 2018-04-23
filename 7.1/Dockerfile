FROM php:7.1-fpm

# install the PHP extensions we need
RUN set -ex; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
	
# copy Drupal config for php
COPY drupal.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/html

ENV NGINX_VERSION 1.9.11-1~jessie

RUN curl -O https://nginx.org/keys/nginx_signing.key && apt-key add ./nginx_signing.key \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get update && apt-get -y install mysql-client

# Install Drush 8
# If the .phar becomes unavailable this could be installed using Composer
# e.g. RUN composer global require drush/drush:"$DRUSH_VERSION" --prefer-dist
RUN curl -OL https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar \
	&& chmod +x drush.phar \
	&& mv drush.phar /usr/local/bin/drush
ENV DRUSH_VERSION 8.1.16
	
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