ARG BUILD_ALPINE_VERSION

FROM alpine:${BUILD_ALPINE_VERSION}

ENV SOCKET_DIR=/.ssh-agent \
    SSH_AUTH_SOCK=/.ssh-agent/socket \
    SSH_AUTH_PROXY_SOCK=/.ssh-agent/proxy-socket \
    SSH_DIR=/.ssh \
    SSH_KEYS_DIR=/.ssh-keys

RUN set -ex; \
    # Install OpenSSH and Socat
    apk add --no-cache openssh socat; \
    # Prepare folders
    mkdir -p \
        ${SOCKET_DIR} \
        ${SSH_DIR} \
        ${SSH_KEYS_DIR}; \
    # Cleanup
    rm -rf /var/cache/apk/*; \
    rm -rf /tmp/*

COPY scripts/*.sh /scripts/
COPY bin/* /bin/

VOLUME ${SOCKET_DIR} \
    ${SSH_KEYS_DIR}

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["ssh-agent"]
