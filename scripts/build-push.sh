#!/bin/bash

#################################################
# Current images
#################################################
# PHP 7.3
docker build -t 3bdigital/drupal-nginx:7.3 7.3
docker push 3bdigital/drupal-nginx:7.3

# PHP 7.3 with nested webroot
docker build -t 3bdigital/drupal-nginx:7.3-webroot 7.3-webroot
docker push 3bdigital/drupal-nginx:7.3-webroot

# PHP 7.4
docker build -t 3bdigital/drupal-nginx:7.4 7.4
docker push 3bdigital/drupal-nginx:7.4

# PHP 7.4 with nested webroot
docker build -t 3bdigital/drupal-nginx:7.4-webroot 7.4-webroot
docker push 3bdigital/drupal-nginx:7.4-webroot



#################################################
# Retired images
#################################################
# PHP 5.5
# docker build -t 3bdigital/drupal-nginx:5.5 5.5
# docker push 3bdigital/drupal-nginx:5.5
#
# PHP 5.6
# docker build -t 3bdigital/drupal-nginx:5.6 5.6
# docker push 3bdigital/drupal-nginx:5.6
#
# PHP 7.0
# docker build -t 3bdigital/drupal-nginx:7.0 7.0
# docker push 3bdigital/drupal-nginx:7.0
#
# PHP 7.0 with nested webroot
# docker build -t 3bdigital/drupal-nginx:7.0-webroot 7.0-webroot
# docker push 3bdigital/drupal-nginx:7.0-webroot
#
# PHP 7.1
# docker build -t 3bdigital/drupal-nginx:7.1 7.1
# docker push 3bdigital/drupal-nginx:7.1
#
# PHP 7.1 with nested webroot
# docker build -t 3bdigital/drupal-nginx:7.1-webroot 7.1-webroot
# docker push 3bdigital/drupal-nginx:7.1-webroot
#
# PHP 7.2
# docker build -t 3bdigital/drupal-nginx:7.2 7.2
# docker push 3bdigital/drupal-nginx:7.2
#
# PHP 7.2 with nested webroot
# docker build -t 3bdigital/drupal-nginx:7.2-webroot 7.2-webroot
# docker push 3bdigital/drupal-nginx:7.2-webroot
