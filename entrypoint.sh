#!/usr/bin/env ash

if [ $# -eq 1 ]
then
  set -f; IFS=' '
  # shellcheck disable=SC2086
  set -- $1
  set +f; unset IFS
fi

cmd_append="-c /root/.pre-commit-config.yaml"
LONG="shell,help,no-build-in-config,env:"
SHORT="shne:"
OPTIONS=$(getopt -l "$LONG" -- "$SHORT" "$@") || exit 1
eval set -- "$OPTIONS"

while true
do
        # shellcheck disable=SC2046
        # shellcheck disable=SC2116
        # shellcheck disable=SC2163
        # shellcheck disable=SC2086
        case "$1" in
        -s|--shell) ash; exit $? ;;
        -n|--no-build-in-config) cmd_append=""; shift;;
        -h|--help) cmd_append="--help";shift $#; break;;
        -e|--env) export $2;shift 2;;
        --) shift;break;;
        *) break;;
        esac
done

# shellcheck disable=SC2086
# shellcheck disable=SC2048
if [ "$CI" = "true" ]
then
  pre-commit $* $cmd_append
else
  cd /builds && git config --global --add safe.directory /builds && pre-commit $* $cmd_append
fi
