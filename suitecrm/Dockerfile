FROM ubuntu:latest

ENV TZ=America/New_York

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN export DEBIAN_FRONTEND='noninteractive' \
    && apt-get update \
    && apt-get install -y \
        ca-certificates apt-transport-https software-properties-common apache2 \
    && rm -rf /var/lib/apt/lists/*


RUN export DEBIAN_FRONTEND='noninteractive' \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        php7.4 \
        libapache2-mod-php7.4 \
        php7.4-fpm \
        libapache2-mod-fcgid \
        php7.4-mysql \
        php7.4-curl \
        php7.4-intl \
        php7.4-zip \
        php7.4-imap \
        php7.4-gd \
        php7.4-xml php7.4-mbstring zlib1g-dev libxml2-dev \
        wget \
        unzip \
        nodejs npm \
        gettext-base \
        vim \
        less \
        git \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*


RUN a2enmod rewrite
RUN a2enconf php7.4-fpm

RUN npm install -g @angular/cli yarn

copy ./docker/config/php/php.ini /etc/php/7.4/apache2/php.ini
copy ./docker/config/fpm/php.ini /etc/php/7.4/fpm/php.ini
copy ./docker/config/cli/php.ini /etc/php/7.4/cli/php.ini
COPY ./docker/config/apache/apache2.conf /etc/apache2/apache2.conf
COPY ./docker/config/apache/sites.conf.template /etc/apache2/sites-enabled/sites.conf.template
RUN mkdir -p /etc/suitecrm
COPY ./docker/entrypoint.sh /etc/suitecrm/entryoint.sh

RUN chown -R www-data:www-data /var/www

ENTRYPOINT ["/etc/suitecrm/entryoint.sh"]

EXPOSE 80
