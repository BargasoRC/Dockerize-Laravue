FROM php:8.2-apache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
    libpng-dev \
    zlib1g-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    zip \
    unzip \
    curl \
    git # Install necessary extensions and tools

RUN docker-php-ext-configure intl # Configure intl extension
RUN docker-php-ext-install pdo_mysql gd zip intl opcache # Install PHP extensions
RUN a2enmod rewrite # Enable Apache rewrite module

WORKDIR /var/www/html

COPY composer.json composer.lock ./

COPY ${SOURCE_LOCATION} .

RUN composer install

RUN /usr/local/bin/php artisan optimize

RUN composer dump-autoload

RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]

