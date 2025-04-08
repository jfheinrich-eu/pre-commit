#!/bin/bash
set -e

PROG=$(which psonoci)
export PSONO_CI_API_KEY_ID="$INPUT_CI_API_KEY_ID"
export PSONO_CI_API_SECRET_KEY_HEX="$INPUT_CI_API_SECRET_KEY_HEX"
export PSONO_CI_SERVER_URL="$INPUT_CI_SERVER_URL"
SECRET_TYPE="$INPUT_SECRET_TYPE"
SECRET_ID="$INPUT_SECRET_ID"
SECRET_FIELDS=($INPUT_SECRET_FIELDS)
MASK_SECRETS=($INPUT_MASK_SECRETS)

# if [ "x$INPUT_SECRET_FIELDS" != "x" ]; then
#     IFS=',' read SECRET_FIELDS <<<$INPUT_SECRET_FIELDS
# fi

# if [ "$INPUT_MASK_SECRETS" != "x" ]; then
#     IFS=',' read MASK_SECRETS <<<$INPUT_MASK_SECRETS
# fi

case "$SECRET_TYPE" in
env)
    command=(env-vars get-or-create)
    ;;
secret)
    command=(secret get)
    ;;
*)
    echo "Unknown SECRET_TYPE: $SECRET_TYPE"
    exit 1
    ;;
esac

for f in ${SECRET_FIELDS[@]}; do
    SECRET_VALUE_NAME=$f

    fetched_secret_name="${SECRET_VALUE_NAME}_fetched"

    IFS= read -r -d '' "$fetched_secret_name" <<<$(${PROG} ${command[0]} ${command[1]} ${SECRET_ID} ${SECRET_VALUE_NAME})

    for m in ${MASK_SECRETS}; do
        if [ "$m" == "$SECRET_VALUE_NAME" ]; then
            echo "::add-mask::${fetched_secret_name}"
        fi
    done

    echo "${SECRET_VALUE_NAME}=${fetched_secret_name}" >>"$GITHUB_OUTPUT"
done
