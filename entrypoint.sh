#!/usr/bin/env ash

if [ $# -eq 1 ]; then
  set -f
  IFS=' '
  # shellcheck disable=SC2086
  set -- $1
  set +f
  unset IFS
fi

usage() {
  cat <<EOF
  Docker image options:

  -i | --image-help          Show this help page
  -s | --shell               Open a shell into the container
  -n | --no-build-in-config  Do not use the internal .pre-commit-config.yaml
  -e | --env                 Set environment variables for pre-commit
  -u | --update-hook         Updates the hook versions in the config file,
                             should used with --no-build-in-config
  -c | --copy-config-example copy the internal pre-commit config as .pre-commit-config-example.yaml
                             into the volume path
EOF
}

update_hooks=
copy_config="false"
image_help="false"
cmd_append="-c /root/.pre-commit-config.yaml"
LONG="image-help,copy-config-example,update-hook:,shell,help,no-build-in-config,env:"
SHORT="u:cishne:"
OPTIONS=$(getopt -l "$LONG" -- "$SHORT" "$@") || exit 1
eval set -- "$OPTIONS"

while true; do
  # shellcheck disable=SC2046
  # shellcheck disable=SC2116
  # shellcheck disable=SC2163
  # shellcheck disable=SC2086
  case "$1" in
  -s | --shell)
    ash
    exit $?
    ;;
  -n | --no-build-in-config)
    cmd_append=""
    shift
    ;;
  -h | --help)
    cmd_append="--help"
    shift $#
    break
    ;;
  -e | --env)
    export $2
    shift 2
    ;;
  -u | --update-hook)
    update_hooks="$2"
    shift 2
    ;;
  -c | --copy-config-example)
    copy_config="true"
    shift
    ;;
  -i | --image-help)
    image_help="true"
    shift
    ;;
  --)
    shift
    break
    ;;
  *) break ;;
  esac
done

# shellcheck disable=SC2086
# shellcheck disable=SC2048
if [ "$CI" = "true" ]; then
  pre-commit $* $cmd_append
else
  if [ "$image_help" = "true" ]; then
    usage
  elif [ "$copy_config" = "true" ]; then
    cp /root/.pre-commit-config.yaml /builds/.pre-commit-config-example.yaml && echo "Example config host://.pre-commit-config-example.yaml created."
  elif [ -n "$update_hooks" ]; then
    pre-commit autoupdate --config $update_hooks
  else
    cd /builds && git config --global --add safe.directory /builds && pre-commit $* $cmd_append
  fi
fi
