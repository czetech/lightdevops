#!/bin/sh
set -e

case $1 in

  ""|http)
    exec nginx -g "daemon off;"
  ;;

  test)
    exec yamllint --config-file .yamllintrc.yaml cicd
  ;;

  *)
    exec "$@"
  ;;

esac

exit 0
