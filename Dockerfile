FROM local/jessie-i386:minbase
MAINTAINER KUSANAGI Mitsuhisa <mikkun@mbg.nifty.com>

ENV LANG ja_JP.utf8
ENV NGINX_VERSION 1.8.0
ENV RTMP_MODULE_VERSION 1.1.7

RUN echo 'debconf debconf/frontend select Noninteractive' \
    | debconf-set-selections
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libav-tools \
    libavcodec-extra \
    libpcre3-dev \
    libssl-dev \
    wget \
    && apt-get clean \
    && find /var/lib/apt/lists \! -name 'lock' -a -type f -print0 \
    | xargs -0 rm -f

WORKDIR /usr/local/src
RUN wget -O - \
    http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    | tar xzf -
RUN wget --no-check-certificate -O - \
    https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_VERSION}.tar.gz \
    | tar xzf -

WORKDIR nginx-${NGINX_VERSION}
RUN ./configure \
    --add-module=../nginx-rtmp-module-${RTMP_MODULE_VERSION} \
    --with-http_ssl_module \
    && make \
    && make install \
    && make clean

WORKDIR /usr/local/nginx
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
VOLUME ["/var/log/nginx"]
EXPOSE 80 1935
CMD ["/usr/local/nginx/sbin/nginx"]
