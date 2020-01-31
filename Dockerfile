FROM gcr.io/google-appengine/php:latest

ENV DOCUMENT_ROOT /app/web
#Database environment variables
ENV MYSQL_DB_NAME ""
ENV MYSQL_DB_USER ""
ENV MYSQL_DB_PASSWORD ""
ENV MYSQL_DB_HOST "127.0.0.1"
ENV MYSQL_DB_PORT "3306"

#Drupal hash salt
ENV DRUPAL_HASH_SALT ""

VOLUME /drupal-files/public
VOLUME /drupal-files/private

WORKDIR /app

COPY . .

RUN composer install

RUN mv -f settings.php web/sites/default/settings.php

#mount the file system here
RUN ln -s /drupal-files/public web/sites/default/files

RUN chown -R www-data.www-data /drupal-files && chmod -R 775 /drupal-files