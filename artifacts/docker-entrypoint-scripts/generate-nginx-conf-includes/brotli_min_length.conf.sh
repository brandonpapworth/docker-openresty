#!/bin/sh
set -eo pipefail

__WARNING_LINE_1="DO NOT MODIFY"
__WARNING_LINE_2="Generated by /docker-entrypoint-scripts/generate-nginx-conf-includes/brotli_min_length.conf.sh"

printf "####\n##  ${__WARNING_LINE_1}\n##  ${__WARNING_LINE_2}\n####\n\n" \
  > ${NGINX__BROTLI_MIN_LENGTH__CONF_FILE_PATH}
printf "brotli_min_length  ${NGINX__BROTLI_MIN_LENGTH};\n" \
  >> ${NGINX__BROTLI_MIN_LENGTH__CONF_FILE_PATH}
