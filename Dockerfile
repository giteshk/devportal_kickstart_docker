FROM gcr.io/google-appengine/php:latest

#Database environment variables
ENV MYSQL_DB_NAME devportaldb
ENV MYSQL_DB_USER devportal_user
ENV MYSQL_DB_PASSWORD devportal_password
ENV MYSQL_DB_HOST 127.0.0.1
ENV MYSQL_DB_PORT 3306

#Drupal hash salt
ENV DRUPAL_HASH_SALT ''

WORKDIR /app

COPY . .

RUN composer install
RUN ln -s web/index.php index.php
RUN ln -s settings.php web/sites/default/settings.php

#mount the file system here
RUN mkdir -p /drupal-files/public /drupal-files/private
RUN ln -s /drupal-files/public web/sites/default/files
RUN chown -R www-data:www-data /drupal-files