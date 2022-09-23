FROM php:8.0-fpm

ARG user
ARG uid

RUN apt-get update && apt-get install -y \
    git \
    curl \ 
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip 

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN chown -R $USER ~/.composer/

RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

WORKDIR /var/www

USER $user