ARG ARCH=
FROM ${ARCH}python:3-alpine

RUN <<EOF
pk update
apk add git --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
pip install pre-commit
pre-commit --version
mkdir /builds
EOF

COPY .pre-commit-config.yaml /builds/.pre-commit-config.yaml
COPY entrypoint.sh /builds/entrypoint.sh

RUN <<EOF
mv /builds/.pre-commit-config.yaml /root/.pre-commit-config.yaml
mv /builds/entrypoint.sh /usr/bin/entrypoint.sh && chmod 755 /usr/bin/entrypoint.sh
EOF

WORKDIR /builds

CMD ["--help"]

ENTRYPOINT ["entrypoint.sh"]
