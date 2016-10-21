#!/bin/sh
set -eo pipefail

__WARNING_LINE_1="DO NOT MODIFY"
__WARNING_LINE_2="Generated by /docker-entrypoint-scripts/generate-nginx-conf-includes/brotli.conf.sh"

printf "####\n##  ${__WARNING_LINE_1}\n##  ${__WARNING_LINE_2}\n####\n\n" \
  > ${NGINX__BROTLI__CONF_FILE_PATH}
printf "brotli  ${NGINX__BROTLI};\n" \
  >> ${NGINX__BROTLI__CONF_FILE_PATH}
