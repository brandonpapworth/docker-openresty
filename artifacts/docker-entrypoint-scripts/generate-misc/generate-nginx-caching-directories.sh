#!/bin/sh
set -e

# Create the caching directories if they do not already exist
if [ ! -d "$NGINX__HTTP__PROXY__TEMP_PATH" ]; then
    mkdir "$NGINX__HTTP__PROXY__TEMP_PATH"
fi
if [ ! -d "$NGINX__HTTP__CLIENT_BODY__TEMP_PATH" ]; then
    mkdir "$NGINX__HTTP__CLIENT_BODY__TEMP_PATH"
fi
if [ ! -d "$NGINX__FCGI__PROXY__TEMP_PATH" ]; then
    mkdir "$NGINX__FCGI__PROXY__TEMP_PATH"
fi
