#!/bin/sh
set -eo pipefail

__WARNING_LINE_1="DO NOT MODIFY"
__WARNING_LINE_2="Generated by /docker-entrypoint-scripts/generate-nginx-conf-includes/brotli_types.conf.sh"

printf "####\n##  ${__WARNING_LINE_1}\n##  ${__WARNING_LINE_2}\n####\n\n" \
  > ${NGINX__BROTLI_TYPES__CONF_FILE_PATH}
printf "brotli_types  ${NGINX__COMPRESSION_TYPES};\n" \
  >> ${NGINX__BROTLI_TYPES__CONF_FILE_PATH}
