# Drupal 8 docker image for GCP

This project is a reference for how to build a Drupal 8 docker image to be deployed on GCP.

You can download this project and add the files to your project to build docker image


## Copy the below files to your project to build your docker image
- Dockerfile
- nginx-http.conf
- php.ini
- settings.php
- Public files for drupal need to be mounted at /drupal-files/public
- Private files for drupal need to be mounted at /drupal-files/private
- Make sure that you have the following dependencies in your composer.json
  You will need to specify the php version.
    ``` 
        "ext-date": "*",
        "ext-dom": "*",
        "ext-filter": "*",
        "ext-gd": "*",
        "ext-hash": "*",
        "ext-json": "*",
        "ext-pcre": "*",
        "ext-pdo": "*",
        "ext-session": "*",
        "ext-simplexml": "*",
        "ext-spl": "*",
        "ext-tokenizer": "*",
        "ext-xml": "*",
        "php": ">=7.2.0"
    ```    
- cloudbuild.xml - Copy this file if you plan to use [Cloud Build](https://cloud.google.com/cloud-build/docs/)

## Building this docker image locally
To build the docker image on your instance run the following:
    
    docker build -t devportal/kickstart .

## Running this setup locally
1. Create a volume for the drupal files
    ```
        docker volume create dev-public-files
        docker volume create dev-private-files
    ```
2.  Create a mariadb database.
    You can setup the mariadb docker container as shown below:
    ```
        docker pull mariadb
    
        docker run --name=dev-db \
            -e MYSQL_ROOT_PASSWORD=rootpassword \
            -e MYSQL_DATABASE=drupal_db \
            -e MYSQL_USER=dbuser \
            -e MYSQL_PASSWORD=passw0rd \
            -p3306:3306 mariadb
    ```    
3. Update the MYSQL_DB_HOST with the IP Address the environment.txt file. Now run the image you just built
    ```
    docker run -v dev-public-files:/drupal-files/public \
        -v dev-private-files:/drupal-files/private \
        --name=dev-drupal  \
        --env-file=./environment.txt \
        -p3000:80 devportal/kickstart:latest 
    ```
4. Open a browser and go to [http://localhost:3000](http://localhost:3000)

## Remove your docker containers

    docker stop dev-drupal
    docker container rm dev-drupal 
    docker stop dev-db
    docker container rm dev-db 
    docker volume rm dev-public-files 
    docker volume rm dev-private-files

## Implementation details

### Dockerfile
    We based this image on the PHP Google App Engine image. 
    We did to leverage all security patches that this image would get from Google team.
    ***As of the writing of this project App Engine image only supports php 7.1 and 7.2***
### nginx-http.conf
    The default nginx configuration is not Drupal friendly so we took the nginx Drupal
    recipe and modified it to work.
### php.ini
    The default 128M was not sufficient for Drupal so we bumped the php memory limit to 512M
### settings.php
    The Database configuration has been parameterized. Define the following environment variables
        - MYSQL_DB_NAME
        - MYSQL_DB_USER
        - MYSQL_DB_PASSWORD
        - MYSQL_DB_HOST
        - MYSQL_DB_PORT
    The Drupal Hash salt is also passed as an environment variable.
        - DRUPAL_HASH_SALT
### composer.json 
    Make sure you have the above mentioned extentions in the require section of your composer.json
    When the docker image is build it uses this information to enable php extensions
### cloudbuild.xml
    Use this to build your docker images using Cloud build and publish to Google container registry.
