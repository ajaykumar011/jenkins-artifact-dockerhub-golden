# https://www.howtoforge.com/tutorial/how-to-create-docker-images-with-dockerfile/
# Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="admin@sysadminjournal.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for \
the PHP-FPM and Nginx Services."
ENV TZ=Asia/Kolkata

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

#configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install nginx, php-fpm and supervisord from ubuntu repository
RUN apt install -y curl wget unzip nginx php-fpm supervisor mysql-client php-mysql php-xml php-mbstring php-cli php-curl gnupg2 \
    phploc phpdox pdepend phpmd php-codesniffer && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
    
# Define the ENV variable
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.4/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

# Enable PHP-fpm on nginx virtualhost configuration
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
    echo "\ndaemon off;" >> ${nginx_conf}

# Copy supervisor configuration
COPY supervisord.conf ${supervisor_conf}

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

#PHP Common settings
RUN sed -i 's#display_errors = Off#display_errors = On#' /etc/php/7.4/fpm/php.ini && \
    sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 100M#' /etc/php/7.4/fpm/php.ini && \
    sed -i 's#post_max_size = 8M#post_max_size = 100M#' /etc/php/7.4/fpm/php.ini && \
    sed -i 's#session.cookie_httponly =#session.cookie_httponly = true#' /etc/php/7.4/fpm/php.ini && \
    sed -i 's#error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = E_ALL#' /etc/php/7.4/fpm/php.ini

#composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

#PHive Installation 

RUN wget -O phive.phar https://phar.io/releases/phive.phar && \
    chmod +x phive.phar && \
    mv phive.phar /usr/local/bin/phive

#PHP Unit
RUN yes | phive install --force-accept-unsigned --global phpunit

# Volume configuration
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Copy start.sh script and define default command for the container
COPY start.sh /start.sh
RUN chmod +x start.sh
CMD ["./start.sh"]

# Expose Port for the Application  #if you are using this in docker-compose then no need to define here.
EXPOSE 80 443 