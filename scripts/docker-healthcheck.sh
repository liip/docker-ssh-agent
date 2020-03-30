#!/bin/sh
set -e;

netstat -nlp | grep -qE "LISTENING.*${SSH_AUTH_PROXY_SOCK}" || exit 1;
netstat -nlp | grep -qE "LISTENING.*${SSH_AUTH_SOCK}" || exit 1;

exit 0;
