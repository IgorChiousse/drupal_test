FROM debian:11.0-slim
ARG NODEJS_VERSION=16.x
ARG PROJECT

COPY etc/apt/apt.conf.d/apt.conf /etc/apt/apt.conf.d/apt.conf

RUN apt-get update \
    && apt install -y --no-install-recommends \
        sed \
    && sed -i 's/http:/https:/g' /etc/apt/sources.list 

RUN apt-get update \
    && apt install -y --no-install-recommends \
        curl \
        wget \
        ca-certificates \
        gnupg \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \    
    && curl -s https://packages.sury.org/php/apt.gpg | gpg --dearmor > /usr/share/keyrings/deb.sury.org-php.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php bullseye main" > /etc/apt/sources.list.d/sury.list \
    && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /usr/share/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODEJS_VERSION} bullseye main" > /etc/apt/sources.list.d/nodejs.list

ARG PHP_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        procps \
        git \
        make \
        iputils-ping \
        telnet \
        sudo \
        unzip \
        vim \
        dos2unix \
        sqlite3 \
        mariadb-client \
        php${PHP_VERSION}-apcu \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-iconv \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-uuid \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-xdebug \
        php${PHP_VERSION}-sqlite3 \
        nginx \
        runit \
        nodejs \
    && npm install -g yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Fake user to maps with the one on the host
RUN addgroup --gid 1000 app && adduser --system --uid 1000 --home /home/app --shell /bin/bash app

RUN useradd -s /bin/false nginx

COPY etc/nginx/environments /etc/nginx/environments
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
ARG WEB_ROOT
RUN sed -i 's,$WEB_ROOT,'${WEB_ROOT}',g' /etc/nginx/nginx.conf
COPY etc/service /etc/service
COPY etc/sudoers.d/sudo /etc/sudoers.d/sudo

COPY php-configuration /etc/php/${PHP_VERSION}

RUN phpenmod app-default && phpenmod app-fpm

# Composer 1
#COPY --from=composer/composer:1.10.27 /usr/bin/composer /usr/bin/composer
# Composer 2
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

RUN mkdir -p "/home/app/.composer/cache" && chown app: /home/app/.composer -R

COPY bashrc /root/.bashrc
RUN dos2unix /root/.bashrc

ARG DRUPAL_VERSION
RUN if [ "$DRUPAL_VERSION" != "" ] ; then composer create-project drupal/recommended-project:$DRUPAL_VERSION /home/app/$PROJECT ; fi

ARG CLONE_REPO
RUN if [ "${CLONE_REPO}" != "" ] ; then git clone ${CLONE_REPO} /home/app/$PROJECT ; fi

EXPOSE 80

RUN chmod +x /etc/service/nginx/run
RUN chmod +x /etc/service/php-fpm/run

CMD ["runsvdir", "-P", "/etc/service"]
