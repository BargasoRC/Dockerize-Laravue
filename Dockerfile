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
RUN a2enmod rewrite headers # Enable Apache rewrite and headers modules

# Configure Apache MaxRequestWorkers (prefork MPM is already enabled by default)
RUN echo "<IfModule mpm_prefork_module>" > /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "    StartServers             8" >> /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "    MinSpareServers          5" >> /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "    MaxSpareServers          20" >> /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "    ServerLimit              256" >> /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "    MaxRequestWorkers        256" >> /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "    MaxConnectionsPerChild   1000" >> /etc/apache2/conf-available/mpm_prefork.conf && \
    echo "</IfModule>" >> /etc/apache2/conf-available/mpm_prefork.conf

RUN a2enconf mpm_prefork

# Configure PHP settings directly
RUN echo "max_execution_time = 300" > /usr/local/etc/php/conf.d/custom.ini && \
    echo "max_input_time = 300" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "opcache.enable = 1" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "opcache.memory_consumption = 128" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "opcache.max_accelerated_files = 4000" >> /usr/local/etc/php/conf.d/custom.ini

# Configure Apache virtual host for Laravel
RUN echo "<VirtualHost *:80>" > /etc/apache2/sites-available/000-default.conf && \
    echo "    DocumentRoot /var/www/html/public" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    ServerName pensclient.localhost" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    <Directory /var/www/html/public>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        AllowOverride All" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        Require all granted" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        Options -Indexes +FollowSymLinks" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    </Directory>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    ErrorLog /var/log/apache2/error.log" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    CustomLog /var/log/apache2/access.log combined" >> /etc/apache2/sites-available/000-default.conf && \
    echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

COPY composer.json composer.lock ./

COPY . .

RUN composer install

RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]

