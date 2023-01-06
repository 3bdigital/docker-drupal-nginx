#!/bin/bash

#################################################
# Current images
#################################################
docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:8.0 8.0
docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:8.1 8.1
docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:8.2 8.2

#################################################
# Retired images
#################################################
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:5.5 5.5
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:5.6 5.6
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.0 7.0
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.0-webroot 7.0-webroot
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.1 7.1
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.1-webroot 7.1-webroot
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.2 7.2
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.2-webroot 7.2-webroot
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.3 7.3
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.3-webroot 7.3-webroot
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.4 7.4
# docker buildx build --push --platform linux/amd64,linux/arm64 -t 3bdigital/drupal-nginx:7.4-webroot 7.4-webroot