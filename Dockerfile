FROM ubuntu:22.04

LABEL maintainer="Alan Facundo Biglieri - Arturo Diehl - 2024"

ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME=your_local_machine_user
ARG USER_UID=1000
RUN useradd -u $USER_UID -ms /bin/bash $USER_NAME
RUN usermod -aG www-data $USER_NAME

RUN apt update

RUN apt install -y software-properties-common unzip curl iproute2 iputils-ping nano supervisor htop git
RUN add-apt-repository -y ppa:ondrej/php
RUN apt update
RUN apt install -y php8.2-cli php8.2-fpm php8.2-common php8.2-mysql php8.2-pgsql php8.2-zip php8.2-gd php8.2-mbstring php8.2-curl php8.2-ldap php8.2-xml php8.2-bcmath
RUN mkdir -p /var/run/php

RUN apt install -y nginx
RUN cd /etc/nginx/sites-available && rm *
RUN cd /etc/nginx/sites-enabled && rm *

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY www.conf /etc/php/8.2/fpm/pool.d/
COPY nginx.conf /etc/nginx/
COPY app.conf /etc/nginx/conf.d/
COPY docker-entrypoint.sh /usr/local/bin/
COPY supervisord.conf /etc/

VOLUME /var/www/app

RUN chmod -R 755 /usr/local/bin/docker-entrypoint.sh


ENTRYPOINT ["docker-entrypoint.sh"]


