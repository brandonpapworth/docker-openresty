# docker-openresty
My own build of Openresty for use in Docker, including LuaRocks.

## Configuration and Paths
  - Install directory: `/usr/local/openresty`
  - Custom Lua library path: `/data/openresty/lualib`

## Configurable Parameters
A collection of `docker-entrypoint` scripts execute at runtime to generate
configuration files for Openresty to include, enabling for configuration of
global settings via environment variables.

| Variable Name                         | Default Value                    |
| ------------------------------------- | -------------------------------- |
| `NGINX__ERROR_LOG_LEVEL`              | `info`                           |
| `NGINX__WORKER_CONNECTIONS`           | `2048`                           |
| `NGINX__WORKER_PROCESSES`             | `1`                              |
| `NGINX__HTTP__LOG_PATH__ACCESS`       | `/dev/stdout`                    |
| `NGINX__HTTP__LOG_CONFIG__ACCESS`     | `"/dev/stdout  combined"`        |
| `NGINX__HTTP__LOG_PATH__ERROR`        | `/dev/stderr`                    |
| `NGINX__HTTP__PROXY__TEMP_PATH`       | `/var/tmp/nginx/tmp_proxy`       |
| `NGINX__HTTP__CLIENT_BODY__TEMP_PATH` | `/var/tmp/nginx/tmp_client_body` |
| `NGINX__FCGI__PROXY__TEMP_PATH`       | `/var/tmp/nginx/tmp_fcgi`        |
| `NGINX__RESOLVER`                     | `8.8.8.8`                        |
| `NGINX__KEEPALIVE_TIMEOUT`            | `65`                             |
| `NGINX__COMPRESSION_TYPES`            | `text/plain text/css ...`        |
| `NGINX__BROTLI`                       | `on`                             |
| `NGINX__BROTLI_STATIC`                | `off`                            |
| `NGINX__BROTLI_COMP_LEVEL`            | `6`                              |
| `NGINX__BROTLI_WINDOW`                | `512k`                           |
| `NGINX__BROTLI_MIN_LENGTH`            | `20`                             |

## Extra Lua Libraries Installed:
  - lua-resty-template
  - lua-resty-validation
  - lua-resty-uuid
  - lua-resty-reqargs
  - lua-resty-session
  - lua-resty-http
