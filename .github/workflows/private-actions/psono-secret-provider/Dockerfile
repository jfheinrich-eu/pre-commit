FROM alpine:latest

COPY entrypoint.sh /entrypoint.sh

RUN sudo apk add --update curl bash && \
    sudo curl https://get.psono.com/psono/psono-ci/x86_64-linux/psonoci --output /usr/bin/psonoci >/dev/null && \
    sudo chmod +x /usr/bin/psonoci && \
    ls -la /usr/bin/psonoci

ENTRYPOINT [ "/entrypoint.sh" ]
