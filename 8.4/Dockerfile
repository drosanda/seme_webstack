FROM php:8.4-fpm-trixie

RUN apt update && \
    apt install -y --no-install-recommends \
    nano wget curl openssh-client zip git make build-essential \
    && apt install -y libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl \
    && mkdir -p -m 0700 ~/.ssh \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions memcached opcache \
    bz2 zip zstd \
    tidy xsl yaml \
    mysqli pgsql \
    pdo_mysql pdo_pgsql \
    mcrypt bcmath \
    gd exif \
    intl xlswriter \
    amqp uuid redis \
    && rm -rf /tmp/* /var/tmp/*

COPY php.ini /usr/local/etc/php/php.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

EXPOSE 9000

RUN groupadd -g 1000 appuser && \
    useradd -r -u 1000 -g appuser -m -s /bin/bash appuser
    
CMD ["sh", "-c", "umask 002 && exec php-fpm -F"]