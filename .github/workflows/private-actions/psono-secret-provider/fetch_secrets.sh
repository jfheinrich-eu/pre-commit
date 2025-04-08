#!/bin/bash
set -e

$PROG=$psonoci

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
