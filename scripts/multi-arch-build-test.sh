#!/bin/bash

#################################################
# Current images (simple build)
#################################################
docker build -t docker-drupal-nginx:8.0 8.0
docker build -t docker-drupal-nginx:8.1 8.1
docker build -t docker-drupal-nginx:8.2 8.2
docker build -t docker-drupal-nginx:8.3 8.3
docker build -t docker-drupal-nginx:8.4 8.4

#################################################
# Current images (multi-arch build)
#################################################
docker buildx build --platform linux/amd64,linux/arm64 -t docker-drupal-nginx:8.0 8.0
docker buildx build --platform linux/amd64,linux/arm64 -t docker-drupal-nginx:8.1 8.1
docker buildx build --platform linux/amd64,linux/arm64 -t docker-drupal-nginx:8.2 8.2
docker buildx build --platform linux/amd64,linux/arm64 -t docker-drupal-nginx:8.3 8.3
docker buildx build --platform linux/amd64,linux/arm64 -t docker-drupal-nginx:8.4 8.4

