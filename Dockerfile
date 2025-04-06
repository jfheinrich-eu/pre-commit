ARG ARCH=
FROM ${ARCH}python:3-alpine3.21
ARG VERSION="develop" \
    BUILD_DATE=""

LABEL   author="Joerg Heinrich <joerg@jfheinrich.eu>" \
    maintainer="contact@jfheinrich.eu" \
    name="jfheinrich/pre-commit" \
    version=${VERSION} \
    description="Image which wrap the pre-commit suite could be used in CD/CD pipelines and on command line" \
    license="MIT" \
    source="https://github.com/jfheinrich-eu/pre-commit.git" \
    org.label-schema.vcs-url="https://github.com/jfheinrich-eu/pre-commit.git" \
    org.label-schema.version=${VERSION} \
    org.opencontainer.image.description="Image which wrap the pre-commit suite could be used in CD/CD pipelines and on command line" \
    org.opencontainer.image.licenses="MIT" \
    org.opencontainer.image.ref.name="alpine" \
    org.opencontainer.image.source="https://github.com/jfheinrich-eu/pre-commit" \
    org.opencontainer.image.title="jfheinrich/pre-commit" \
    org.opencontainer.image.url="https://hub.docker.com/r/jfheinrich/pre-commit" \
    org.opencontainer.image.vendor="J.F.Heinrich" \
    org.opencontainer.image.version=${VERSION} \
    org.opencontainer.image.authors="Joerg Heinrich <joerg@jfheinrich.eu>" \
    org.opencontainer.image.created="${BUILD_DATE}"

COPY .pre-commit-config.yaml /root/.pre-commit-config.yaml
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN apk add --update --no-cache \
    'xz-libs>=5.6.3-r1' \
    git --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
    php83 php83-pecl-xdebug --repository=https://dl-cdn.alpinelinux.org/alpine/v3.21/community && \
    pip install pre-commit

WORKDIR /builds

CMD ["--help"]

ENTRYPOINT ["entrypoint.sh"]
