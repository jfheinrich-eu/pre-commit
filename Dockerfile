ARG ARCH=
FROM ${ARCH}python:3-alpine3.21
ARG VERSION="develop"
ARG BUILD_DATE=""

LABEL author="Joerg Heinrich <joerg@jfheinrich.eu>"
LABEL maintainer="contact@jfheinrich.eu"
LABEL name="jfheinrich/pre-commit"
LABEL version=${VERSION}
LABEL description="Image which wrap the pre-commit suite could be used in CD/CD pipelines and on command line"
LABEL license="MIT"
LABEL source="https://gitlab.com/jfheinrich-dev/pre-commit.git"

LABEL org.label-schema.vcs-url="https://gitlab.com/jfheinrich-dev/pre-commit.git"
LABEL org.label-schema.version=${VERSION}

LABEL org.opencontainer.image.description="Image which wrap the pre-commit suite could be used in CD/CD pipelines and on command line"
LABEL org.opencontainer.image.licenses="MIT"
LABEL org.opencontainer.image.ref.name="alpine"
LABEL org.opencontainer.image.source="https://gitlab.com/jfheinrich-dev/pre-commit.git"
LABEL org.opencontainer.image.title="jfheinrich/pre-commit"
LABEL org.opencontainer.image.url="https://jfheinrich.eu"
LABEL org.opencontainer.image.vendor="J.F.Heinrich"
LABEL org.opencontainer.image.version=${VERSION}
LABEL org.opencontainer.image.authors="Joerg Heinrich <joerg@jfheinrich.eu>"
LABEL org.opencontainer.image.created="${BUILD_DATE}"

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
