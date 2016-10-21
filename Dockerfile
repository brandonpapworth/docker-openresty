FROM alpine:3.4
MAINTAINER Brandon Papworth <brandon@papworth.me>

ENV OPENRESTY__PREFIX=/usr/local/openresty \
    NGINX__RUN_PREFIX=/var/run/nginx \
    NGINX__LOCK_PREFIX=/var/lock/nginx \
    NGINX__TMP_PREFIX=/var/tmp/nginx \
    NGINX__LOG_PREFIX=/var/log/nginx \
    OPENRESTY__CUSTOM_LUA_PATH=/data/openresty/lualib \
    NGINX__ERROR_LOG_LEVEL=info \
    NGINX__WORKER_CONNECTIONS=2048 \
    NGINX__WORKER_PROCESSES=1 \
    NGINX__HTTP__LOG_PATH__ACCESS=/dev/stdout \
    NGINX__HTTP__LOG_CONFIG__ACCESS="/dev/stdout  combined" \
    NGINX__HTTP__LOG_PATH__ERROR=/dev/stderr \
    NGINX__RESOLVER=8.8.8.8 \
    NGINX__KEEPALIVE_TIMEOUT=65 \
    NGINX__COMPRESSION_TYPES="text/plain text/css text/javascript text/xml application/json application/x-javascript application/graphql application/x-graphql application/xml application/xml+rss application/x-www-form-urlencoded application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon" \
    NGINX__BROTLI=on \
    NGINX__BROTLI_STATIC=off \
    NGINX__BROTLI_COMP_LEVEL=6 \
    NGINX__BROTLI_WINDOW=512k \
    NGINX__BROTLI_MIN_LENGTH=20

ENV NGINX__PREFIX="$OPENRESTY__PREFIX/nginx"

ENV NGINX__CONF_PREFIX="$NGINX__PREFIX/conf" \
    PATH="$PATH:$NGINX__PREFIX/sbin:$OPENRESTY__PREFIX/bin:$OPENRESTY__PREFIX/luajit/bin"

WORKDIR $NGINX__PREFIX/

VOLUME ["/var/run/nginx", "/var/lock/nginx", "/var/tmp/nginx", "/var/log/nginx"]

COPY ["artifacts/docker-entrypoint.sh", "/"]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx"]

ENV NGINX__PID_PATH="$NGINX__RUN_PREFIX/nginx.pid" \
    NGINX__LOCK_PATH="$NGINX__LOCK_PREFIX/nginx.lock" \
    NGINX__ERROR_LOG__CONF_FILE_PATH="$NGINX__CONF_PREFIX/error_log.conf" \
    NGINX__WORKER_CONNECTIONS__CONF_FILE_PATH="$NGINX__CONF_PREFIX/worker_connections.conf" \
    NGINX__WORKER_PROCESSES__CONF_FILE_PATH="$NGINX__CONF_PREFIX/worker_processes.conf" \
    NGINX__HTTP__LOG_CONFIG__ACCESS__CONF_FILE_PATH="$NGINX__CONF_PREFIX/access_log_http.conf" \
    NGINX__HTTP__PROXY__TEMP_PATH="$NGINX__TMP_PREFIX/tmp_proxy" \
    NGINX__HTTP__CLIENT_BODY__TEMP_PATH="$NGINX__TMP_PREFIX/tmp_client_body" \
    NGINX__FCGI__PROXY__TEMP_PATH="$NGINX__TMP_PREFIX/tmp_fcgi" \
    NGINX__ENV__CONF_FILE_PATH="$NGINX__CONF_PREFIX/env_vars_available.conf" \
    NGINX__ENV__LUA_FILE_PATH="$OPENRESTY__PREFIX/lualib/generated/env_vars_available.lua" \
    NGINX__RESOLVER__CONF_FILE_PATH="$NGINX__CONF_PREFIX/resolver.conf" \
    NGINX__KEEPALIVE_TIMEOUT__CONF_FILE_PATH="$NGINX__CONF_PREFIX/keepalive_timeout.conf" \
    NGINX__GZIP_TYPES__CONF_FILE_PATH="$NGINX__CONF_PREFIX/gzip_types.conf" \
    NGINX__BROTLI__CONF_FILE_PATH="$NGINX__CONF_PREFIX/brotli.conf" \
    NGINX__BROTLI_STATIC__CONF_FILE_PATH="$NGINX__CONF_PREFIX/brotli_static.conf" \
    NGINX__BROTLI_COMP_LEVEL__CONF_FILE_PATH="$NGINX__CONF_PREFIX/brotli_comp_level.conf" \
    NGINX__BROTLI_WINDOW__CONF_FILE_PATH="$NGINX__CONF_PREFIX/brotli_window.conf" \
    NGINX__BROTLI_MIN_LENGTH__CONF_FILE_PATH="$NGINX__CONF_PREFIX/brotli_min_length.conf" \
    NGINX__BROTLI_TYPES__CONF_FILE_PATH="$NGINX__CONF_PREFIX/brotli_types.conf"

COPY ["artifacts/docker-entrypoint-scripts", "/docker-entrypoint-scripts"]

ENV OPENRESTY__VERSION=1.11.2.1 \
    NGINX__VERSION=1.11.2 \
    LUAJIT__VERSION=2.1.0-beta2 \
    LUAROCKS__VERSION=2.4.1

LABEL org.openresty.version="1.11.2.1" \
      org.nginx.version="1.11.2" \
      org.luajit.version="2.1.0-beta2" \
      org.luarocks.version="2.4.1"

RUN ALPINE__CONTAINER_DEPS=" \
    libpcrecpp \
    libpcre16 \
    libpcre32 \
    musl-dev \
    pcre-dev \
    openssl-dev \
    zlib-dev \
    ncurses-dev \
    readline-dev \
    curl \
    unzip \
    perl \
    make \
    gcc \
    tar \
    openssl \
    libssl1.0 \
    pcre \
    libgcc \
    libstdc++ \
    libpq \
    postgresql-dev \
    git \
    libtool \
    autoconf \
    automake \
" \
 && echo "docker-build-script: Updating APK and installing build dependencies" \
 && apk update \
 && apk upgrade \
 && apk add $ALPINE__CONTAINER_DEPS \
 && rm -rf /var/cache/apk/*

RUN echo "docker-build-script: Downloading and extracting libbrotli" \
 && cd /root \
 && git clone https://github.com/bagder/libbrotli \
 && cd /root/libbrotli \
 && echo "docker-build-script: Configuring libbrotli" \
 && ./autogen.sh \
 && ./configure \
 && echo "docker-build-script: Compiling libbrotli" \
 && make \
 && echo "docker-build-script: Installing libbrotli" \
 && make install \
 && echo "docker-build-script: Deleting libbrotli source" \
 && cd /root \
 && rm -rf /root/libbrotli \
 && echo "docker-build-script: Downloading and extracting ngx_brotli" \
 && cd /root \
 && git clone https://github.com/google/ngx_brotli \
 && echo "docker-build-script: Creating Openresty directories for build" \
 && mkdir -p /root/openresty \
 && cd /root/openresty \
 && echo "docker-build-script: Downloading and extracting Openresty" \
 && curl -sSL http://openresty.org/download/openresty-${OPENRESTY__VERSION}.tar.gz | tar -xvz \
 && cd openresty-* \
 && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && echo "docker-build-script: Configuring Openresty for compilation" \
 && ./configure \
    --prefix=$OPENRESTY__PREFIX \
    --http-client-body-temp-path=$NGINX__HTTP__CLIENT_BODY__TEMP_PATH \
    --http-fastcgi-temp-path=$NGINX__FCGI__PROXY__TEMP_PATH \
    --http-proxy-temp-path=$NGINX__HTTP__PROXY__TEMP_PATH \
    --http-log-path=$NGINX__HTTP__LOG_PATH__ACCESS \
    --error-log-path=$NGINX__HTTP__LOG_PATH__ERROR \
    --pid-path=$NGINX__PID_PATH \
    --lock-path=$NGINX__LOCK_PATH \
    --with-luajit \
    --with-pcre-jit \
    --with-ipv6 \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_v2_module \
    --with-http_mp4_module \
    --with-http_postgres_module \
    --with-threads \
    --add-module=/root/ngx_brotli \
    -j${NPROC} \
 && echo "docker-build-script: Compiling Openresty" \
 && make -j${NPROC} \
 && echo "docker-build-script: Installing Openresty" \
 && make install \
 && echo "docker-build-script: Creating normalizing symlinks for Openresty and Lua" \
 && ln -sf $NGINX__PREFIX/sbin/nginx $NGINX__PREFIX/sbin/openresty \
 && ln -sf $OPENRESTY__PREFIX/luajit/bin/luajit-* $OPENRESTY__PREFIX/luajit/bin/lua \
 && echo "docker-build-script: Creating folder '$OPENRESTY__PREFIX/lualib/util' for misc utilities" \
 && mkdir -p $OPENRESTY__PREFIX/lualib/util \
 && echo "docker-build-script: Creating folder '$OPENRESTY__PREFIX/lualib/generated' for runtime-generated lua files" \
 && mkdir -p $OPENRESTY__PREFIX/lualib/generated \
 && echo "docker-build-script: Creating folder '$OPENRESTY__CUSTOM_LUA_PATH' for custom lua libraries" \
 && mkdir -p $OPENRESTY__CUSTOM_LUA_PATH \
 && echo "docker-build-script: Downloading and extracting LuaRocks" \
 && cd /root \
 && curl -sSL http://keplerproject.github.io/luarocks/releases/luarocks-${LUAROCKS__VERSION}.tar.gz | tar -zxp \
 && mv /root/luarocks-${LUAROCKS__VERSION} /root/luarocks \
 && cd /root/luarocks \
 && echo "docker-build-script: Configuring LuaRocks for compilation" \
 && ./configure \
    --prefix=${OPENRESTY__PREFIX}/luajit \
    --with-lua=${OPENRESTY__PREFIX}/luajit \
    --lua-suffix=jit-${LUAJIT__VERSION} \
    --with-lua-include=${OPENRESTY__PREFIX}/luajit/include/luajit-2.1 \
 && echo "docker-build-script: Compiling LuaRocks" \
 && make \
 && echo "docker-build-script: Installing LuaRocks" \
 && make install \
 && ln -s ${OPENRESTY__PREFIX}/luajit/bin/luarocks /usr/bin/luarocks \
 && echo "docker-build-script: Cleaning up..." \
 && cd / \
 && rm -rf /root/openresty* \
 && rm -rf /root/luarocks* \
 && echo "docker-build-script: Openresty build, installation, and cleanup complete"

RUN echo "docker-build-script: Downloading and installing LuaRocks includes" \
 && luarocks install lua-resty-template \
 && luarocks install lua-resty-validation \
 && luarocks install lua-resty-uuid \
 && luarocks install lua-resty-reqargs \
 && luarocks install lua-resty-session \
 && luarocks install lua-resty-http

COPY artifacts/env.lua $OPENRESTY__PREFIX/lualib/util/env.lua
COPY artifacts/nginx.conf $NGINX__PREFIX/conf/nginx.conf
COPY artifacts/default.conf $NGINX__PREFIX/conf/sites_enabled/default.conf
