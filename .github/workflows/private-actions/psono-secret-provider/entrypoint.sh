#!/bin/bash
set -e

PROG=$(which psonoci)
PSONO_CI_API_KEY_ID="$INPUT_CI_API_KEY_ID"
PSONO_CI_API_SECRET_KEY_HEX="$INPUT_CI_API_SECRET_KEY_HEX"
PSONO_CI_SERVER_URL="$INPUT_CI_SERVER_URL"
SECRET_TYPE="$INPUT_SECRET_TYPE"
SECRET_FIELDS=()
MASK_SECRETS=()

if [ -n "$INPUT_SECRET_FIELDS" ]; then
    IFS=, read line <<<$INPUT_SECRET_FIELDS
    SECRET_FIELDS=($line)
fi

if [ -n "$INPUT_MASK_SECRETS" ]; then
    IFS=, read line <<<$INPUT_MASK_SECRETS
    MASK_SECRETS=($line)
fi

case "$SECRET_TYPE" in
env)
    command="env-vars get-or-create"
    ;;
secret)
    command="secret get"
    ;;
*)
    echo "Unknown SECRET_TYPE: $SECRET_TYPE"
    exit 1
    ;;
esac

for f in ${SECRET_FIELDS[*]}; do
    SECRET_VALUE_NAME=$f

    $fetched_secret_name="${SECRET_VALUE_NAME}_fetched"

    IFS= read -r -d '' "$fetched_secret_name" <<<"$(${PROG} ${command} ${SECRET_ID} {SECRET_VALUE_NAME})"

    for m in ${MASK_SECRETs[*]}; do
        if [ "$m" == "$SECRET_VALUE_NAME" ]; then
            echo "::add-mask::${fetched_secret_name}"
        fi
    done

    echo "${SECRET_VALUE_NAME}=${fetched_secret_name}" >>"$GITHUB_OUTPUT"
done
