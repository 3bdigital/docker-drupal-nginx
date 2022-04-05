FROM php:7.2-fpm

# Install the PHP extensions we need
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
# Reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
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

# Set recommended php.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
	
RUN yes | pecl install igbinary-2.0.8 redis-4.2.0 \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
	&& echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini
	
# Copy Drupal config for PHP
COPY drupal.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/web

# Install NGINX
ENV NGINX_VERSION 1.21.6-1~buster

RUN apt-get update && apt-get install -y gnupg

RUN curl -O https://nginx.org/keys/nginx_signing.key && apt-key add ./nginx_signing.key \
	&& echo "deb http://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# Forward request and error logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Install MariaDB client
RUN apt-get update && apt-get -y install mariadb-client

# Add projects's Composer bin directory to PATH. This will allow Drush to be run.
RUN echo "export PATH=\"/var/www/vendor/bin:$PATH\"" >> ~/.bashrc
	
EXPOSE 80 443

# Add a dummp SSL certificate and key
COPY ssl/dev.3bweb.com.crt /etc/nginx/ssl/dev.3bweb.com.crt
COPY ssl/dev.3bweb.com.key /etc/nginx/ssl/dev.3bweb.com.key

# Drupal config for NGINX
COPY nginx.conf /etc/nginx/nginx.conf
COPY drupal.conf /etc/nginx/conf.d/default.conf

# Drupal config for PHP
COPY opcache-recommended.ini drupal.ini /usr/local/etc/php/conf.d/

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD php-fpm -D && nginx -g 'daemon off;'