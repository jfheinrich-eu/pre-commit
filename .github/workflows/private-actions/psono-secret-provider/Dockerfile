FROM alpine:latest

COPY entrypoint.sh /entrypoint.sh

RUN apk add --update curl && \
    curl https://get.psono.com/psono/psono-ci/x86_64-linux/psonoci --output /usr/bin/psonoci >/dev/null && chmod +x /usr/bin/psonoci

ENTRYPOINT [ "/entrypoint.sh" ]
