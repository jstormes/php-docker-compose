FROM php:7-apache

############################################################################
# Install Internationalization
############################################################################
RUN apt-get -y update \
&& apt-get install -y libicu-dev \
&& docker-php-ext-configure intl \
&& docker-php-ext-install intl

############################################################################
# Install MySQL PDO
#########################################################################
RUN docker-php-ext-install pdo pdo_mysql \
&& docker-php-ext-configure pdo_mysql

############################################################################
# Install Apache modules
############################################################################
RUN a2enmod rewrite