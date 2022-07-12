FROM webdevops/php-nginx:7.2

ARG PSR_VERSION=0.7.0
ARG PHALCON_VERSION=3.4.0
ARG PHALCON_EXT_PATH=php7/64bits

RUN set -xe && \
    # Download PSR, see https://github.com/jbboehr/php-psr
    curl -LO https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz && \
    tar xzf ${PWD}/v${PSR_VERSION}.tar.gz && \
    # Download Phalcon
    curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz && \
    docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) \
        ${PWD}/php-psr-${PSR_VERSION} \
        ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} \
    && \
    # Remove all temp files
    rm -r \
        ${PWD}/v${PSR_VERSION}.tar.gz \
        ${PWD}/php-psr-${PSR_VERSION} \
        ${PWD}/v${PHALCON_VERSION}.tar.gz \
        ${PWD}/cphalcon-${PHALCON_VERSION} \
    && \
    php -m

RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
 
#RUN composer require --dev phalcon/devtools

#RUN vendor/bin/phalcon project app simple

ENV WEB_DOCUMENT_ROOT=/var/www/html/app/public

RUN chown -R root:www-data /app
RUN chmod u+rwx,g+rx,o+rx /app
RUN find /app -type d -exec chmod u+rwx,g+rx,o+rx {} +
RUN find /app -type f -exec chmod u+rw,g+rw,o+r {} +

#RUN usermod -u 1000 www-data

EXPOSE 9000





