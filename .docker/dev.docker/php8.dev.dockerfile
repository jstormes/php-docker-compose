FROM php:8

############################################################################
# Install system commands and libraries
############################################################################
RUN apt-get -y update \
    && apt-get install -y \
       curl \
       wget \
       git \
       zip \
       unzip

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
# Install MySQL client
############################################################################
RUN apt-get install -y default-mysql-client

############################################################################
# Setup XDebug https://xdebug.org/download/historical
# xdebug-x.x.x for specific version
############################################################################
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

############################################################################
# Create proper security higene for enviornemnt.
# Manage SSH keys https://medium.com/trabe/use-your-local-ssh-keys-inside-a-docker-container-ea1d117515dc
############################################################################
ENV GIT_SSL_NO_VERIFY="1"
RUN useradd -m user \
    && mkdir -p /home/user/.ssh \
    && echo "Host *\n\tStrictHostKeyChecking no\n" >> /home/user/.ssh/config \
    && chown -R user:user /home/user/.ssh \
    && echo "naked\nnaked" | passwd root \
    && echo "alias mysql='mysql --user=root'" >> /home/user/.bashrc


USER user
WORKDIR /app
CMD ["/bin/bash"]
# Add our script files to the path so they can be found
ENV PATH /app/bin:$PATH

############################################################################
# Install PHP Composer https://getcomposer.org/download/
# Add "--version=1.10.22" after "php --" to get a specific version.
############################################################################
RUN cd ~ \
    && mkdir bin \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer.phar \
    && chmod u+x ~/bin/composer.phar \
    && echo "#!/usr/bin/env bash\n\nXDEBUG_MODE=off ~/bin/composer.phar \$@" > ~/bin/composer \
    && chmod u+x ~/bin/composer


# Add our script files to the path so they can be found
ENV PATH /app/vendor/bin:/var/www/vendor/bin:~/bin:~/.composer/vendor/bin:$PATH

############################################################################
# Isntall Codeception native
############################################################################
RUN curl -LsS https://codeception.com/codecept.phar -o ~/bin/codecept \
    && chmod u+x ~/bin/codecept \
    && echo "alias codecept='XDEBUG_MODE=off ~/bin/codecept'" >> /home/user/.bashrc

