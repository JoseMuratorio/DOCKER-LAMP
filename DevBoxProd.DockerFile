FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    # Install git
    git \
    # Install apache
    apache2 \
    # Install php 7.2
    libapache2-mod-php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    php7.2-simplexml \
    php7.2-imagick \
    php7.2-bcmath \
    # Install tools
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    mysql-client \
    iputils-ping \
    locales \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt update
#pass APACHE config
COPY 000-default.conf /etc/apache2/sites-available 
COPY php.ini /etc/php/7.2/apache2/
COPY openssl.cnf /etc/ssl
RUN openssl genrsa -out ca.key 2048
RUN openssl req -nodes -new -key ca.key -out ca.csr -subj '/CN=127.0.0.1/O=test./C=AR'
RUN  openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
RUN mkdir /etc/apache2/ssl
RUN cp ca.crt ca.key ca.csr /etc/apache2/ssl/



#BACKUP

RUN apt install -yq unzip 
RUN apt install -yq cron
RUN apt install -yq wget
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


CMD ["apachectl","-D","FOREGROUND"]
RUN a2enmod rewrite
RUN a2enmod ssl
EXPOSE 80
EXPOSE 443