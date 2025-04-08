#!/bin/bash
set -e

PROG=$(which psonoci)
PSONO_CI_API_KEY_ID="$1"
PSONO_CI_API_SECRET_KEY_HEX="$2"
PSONO_CI_SERVER_URL="$3"
SECRET_TYPE="$4"
SECRET_FIELDS="$5"
MASK_SECRETS="$6"

echo "ci_server_url: $INPUT_CI_SERVER_URL"

case "$SECRET_TYPE" in
env)
    command="env-vars get-or-create"
    break
    ;;
secret)
    command="secret get"
    break
    ;;
esac

for f in $(echo $SECRET_FIELDS |  tr ',' ' '); do
    SECRET_VALUE_NAME=$f

    $fetched_secret_name="${SECRET_VALUE_NAME}_fetched"

    ORG_IFS=${IFS}
    IFS= read -r -d '' "$fetched_secret_name" <<<"$(${PROG} ${command} ${SECRET_ID} {SECRET_VALUE_NAME})"
    IFS=${ORG_IFS}

    for m in $(echo $MASK_SECRET | tr ',' ' '); do
        if [ "$m" == "$SECRET_VALUE_NAME" ]; then
            echo "::add-mask::${fetched_seceret_name}"
        fi
    done

    echo "${SECRET_VALUE_NAME}=${fetched_secret_name}" >>"$GITHUB_OUTPUT"
done
