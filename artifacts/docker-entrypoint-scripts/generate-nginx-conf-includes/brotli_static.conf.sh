#!/bin/sh
set -eo pipefail

__WARNING_LINE_1="DO NOT MODIFY"
__WARNING_LINE_2="Generated by /docker-entrypoint-scripts/generate-nginx-conf-includes/brotli_static.conf.sh"

printf "####\n##  ${__WARNING_LINE_1}\n##  ${__WARNING_LINE_2}\n####\n\n" \
  > ${NGINX__BROTLI_STATIC__CONF_FILE_PATH}
printf "brotli_static  ${NGINX__BROTLI_STATIC};\n" \
  >> ${NGINX__BROTLI_STATIC__CONF_FILE_PATH}
