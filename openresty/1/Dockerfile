FROM alpine:3.4
MAINTAINER Brandon Papworth <brandon@papworth.me>


ENV OPENRESTY__PREFIX=/etc/openresty \
    NGINX__PREFIX=/etc/openresty/nginx \
    NGINX__PID_PATH=/var/run/nginx/nginx.pid \
    NGINX__LOCK_PATH=/var/run/nginx/nginx.lock \
    NGINX__ERROR_LOG_LEVEL=info \
    NGINX__ERROR_LOG__CONF_FILE_PATH=/etc/openresty/nginx/error_log.conf \
    NGINX__WORKER_CONNECTIONS=2048 \
    NGINX__WORKER_CONNECTIONS__CONF_FILE_PATH=/etc/openresty/nginx/worker_connections.conf \
    NGINX__WORKER_PROCESSES=auto \
    NGINX__WORKER_PROCESSES__CONF_FILE_PATH=/etc/openresty/nginx/worker_connections.conf \
    NGINX__HTTP__LOG_PATH__ACCESS=/var/log/nginx/access.log \
    NGINX__HTTP__LOG_PATH__ERROR=/var/log/nginx/error.log \
    NGINX__HTTP__PROXY__TEMP_PATH=/var/tmp/nginx/tmp_proxy \
    NGINX__HTTP__CLIENT_BODY__TEMP_PATH=/var/tmp/nginx/tmp_client_body \
    NGINX__FCGI__PROXY__TEMP_PATH=/var/tmp/nginx/tmp_fcgi \
    OPENRESTY__CUSTOM_LUA_PATH=/data/openresty/lualib \
    NGINX__ENV__CONF_FILE_PATH=/etc/openresty/nginx/conf/env_vars_available.conf \
    NGINX__ENV__LUA_FILE_PATH=/etc/openresty/lualib/generated/env_vars_available.lua

ENV OPENRESTY__VERSION=1.9.15.1 \
    NGINX__VERSION=1.9.15 \
    LUAJIT__VERSION=2.1.0-beta2 \
    LUAROCKS__VERSION=2.3.0

LABEL org.openresty.version="1.9.15.1" \
      org.nginx.version="1.9.15" \
      org.luajit.version="2.1.0-beta2" \
      org.luarocks.version="2.3.0"

RUN ALPINE__BUILD_DEPS=" \
    musl-dev \
    pcre-dev \
    openssl-dev \
    zlib-dev \
    ncurses-dev \
    readline-dev \
    curl \
    perl \
    make \
    gcc \
    tar \
" \
 && ALPINE__CONTAINER_DEPS=" \
    libpcrecpp \
    libpcre16 \
    libpcre32 \
    openssl \
    libssl1.0 \
    pcre \
    libgcc \
    libstdc++ \
" \
 && echo "docker-build-script: Updating APK and installing build dependencies" \
 && apk update \
 && apk add $ALPINE__BUILD_DEPS \
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
    --with-threads \
    -j${NPROC} \
 && echo "docker-build-script: Compiling Openresty" \
 && make -j${NPROC} \
 && echo "docker-build-script: Installing Openresty" \
 && make install \
 && echo "docker-build-script: Creating symlinks for Openresty" \
 && ln -sf $NGINX__PREFIX/sbin/nginx /usr/local/bin/nginx \
 && ln -sf $NGINX__PREFIX/sbin/nginx /usr/local/bin/openresty \
 && ln -sf $OPENRESTY__PREFIX/bin/resty /usr/local/bin/resty \
 && ln -sf $OPENRESTY__PREFIX/luajit/bin/luajit-* $OPENRESTY__PREFIX/luajit/bin/lua \
 && ln -sf $OPENRESTY__PREFIX/luajit/bin/luajit-* /usr/local/bin/lua \
 && echo "docker-build-script: Creating folder '$OPENRESTY__PREFIX/lualib/util' for misc utilities" \
 && mkdir -p $OPENRESTY__PREFIX/lualib/util \
 && echo "docker-build-script: Creating folder '$OPENRESTY__PREFIX/lualib/generated' for runtime-generated lua files" \
 && mkdir -p $OPENRESTY__PREFIX/lualib/generated \
 && echo "docker-build-script: Creating folder '$OPENRESTY__CUSTOM_LUA_PATH' for custom lua libraries" \
 && mkdir -p $OPENRESTY__CUSTOM_LUA_PATH \
 && echo "docker-build-script: Creating placeholder '$OPENRESTY__PREFIX/lualib/generated/env_vars_available.lua'" \
 && touch $OPENRESTY__PREFIX/lualib/generated/env_vars_available.lua \
 && echo "docker-build-script: Creating placeholder '$NGINX__PREFIX/conf/env_vars_available.conf'" \
 && touch $NGINX__PREFIX/conf/env_vars_available.conf \
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
 && echo "docker-build-script: Deleting Openresty build dependencies" \
 && apk del $ALPINE__BUILD_DEPS \
 && echo "docker-build-script: Installing Openresty runtime dependencies" \
 && apk add $ALPINE__CONTAINER_DEPS \
 && echo "docker-build-script: Cleaning up..." \
 && cd / \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/openresty* \
 && rm -rf /root/luarocks* \
 && echo "docker-build-script: Openresty build, installation, and cleanup complete"

WORKDIR $NGINX__PREFIX/

VOLUME ["/var/log/nginx", "/var/run/nginx", "/var/tmp/nginx"]

COPY artifacts/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

COPY artifacts/env.lua $OPENRESTY__PREFIX/lualib/util/env.lua
COPY artifacts/nginx.conf $NGINX__PREFIX/conf/nginx.conf
COPY artifacts/default.conf $NGINX__PREFIX/conf/sites_enabled/default.conf

CMD ["nginx"]
