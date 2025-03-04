FROM python:3-alpine as base

RUN <<EOF
apk add --update git
pip install pre-commit
pre-commit --version
mkdir /builds
EOF

COPY .pre-commit-config.yaml /builds/pre-commit-config.yaml
COPY entrypoint.sh /builds/entrypoint.sh

WORKDIR /builds

RUN <<EOF
mv /builds/.pre-commit-config.yaml ~/.pre-commit-config.yaml
mv /builds/entrypoint.sh /usr/bin/entrypoint.sh && chmod 755 /usr/bin/entrypoint.sh
EOF

FROM base as final

WORKDIR /builds

CMD ["--help"]

ENTRYPOINT ["entrypoint.sh"]
