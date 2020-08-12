#!/bin/bash

chown -R www-data:www-data /var/www/web/sites/default/files

exec "$@"