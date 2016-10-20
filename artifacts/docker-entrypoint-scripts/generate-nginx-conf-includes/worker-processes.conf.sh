#!/bin/sh
set -eo pipefail

__WARNING_LINE_1="DO NOT MODIFY"
__WARNING_LINE_2="Generated by /docker-entrypoint-scripts/generate-nginx-conf-includes/worker-processes.conf.sh"

printf "####\n##  ${__WARNING_LINE_1}\n##  ${__WARNING_LINE_2}\n####\n\n" \
  > ${NGINX__WORKER_PROCESSES__CONF_FILE_PATH}
printf "worker_processes  ${NGINX__WORKER_PROCESSES};\n" \
  >> ${NGINX__WORKER_PROCESSES__CONF_FILE_PATH}