ARG ARCH=
FROM ${ARCH}python:3-alpine3.21
ARG VERSION="develop"

LABEL maintainer="contact@jfheinrich.eu"
LABEL version=${VERSION}
LABEL description="Image which wrap the pre-commit suite could be used in CD/CD pipelines and on command line"
LABEL license="MIT"
LABEL source="https://gitlab.com/jfheinrich-dev/pre-commit.git"

RUN <<EOF
apk update
apk add git --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
apk add php83 php83-pecl-xdebug --repository=https://dl-cdn.alpinelinux.org/alpine/v3.21/community
pip install pre-commit
pre-commit --version
git --version
EOF

COPY .pre-commit-config.yaml /root/.pre-commit-config.yaml
COPY entrypoint.sh /usr/bin/entrypoint.sh

#RUN <<EOF
#mv /builds/.pre-commit-config.yaml /root/.pre-commit-config.yaml
#mv /builds/entrypoint.sh /usr/bin/entrypoint.sh && chmod 755 /usr/bin/entrypoint.sh
#EOF

WORKDIR /builds

CMD ["--help"]

ENTRYPOINT ["entrypoint.sh"]
