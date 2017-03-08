# Configure odbc
FROM php:5.6-fpm
RUN apt-get update && apt-get install -y unixodbc-dev && rm -rf /var/lib/apt/lists/*
RUN docker-php-source extract \
    && set -x \
    && cd /usr/src/php/ext/odbc \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && docker-php-ext-configure odbc --with-unixODBC=shared,/usr \
    && docker-php-ext-install odbc \
    && docker-php-ext-enable odbc \
    && docker-php-source delete \
    && php -m

RUN set -ex \
 && { \
  echo '[ODBC Data Sources]'; \
  echo 'VOS = Virtuoso'; \
  echo; \
  echo '[VOS]'; \
  echo 'Driver = /usr/local/virtuoso-opensource/lib/virtodbc.so'; \
  echo 'Address = virtuoso:1111'; \
 } | tee /etc/odbc.ini
