#!/bin/sh
set -e;

if [ "$1" = 'ssh-agent' ]; then
	rm -f ${SSH_AUTH_SOCK} ${SSH_AUTH_PROXY_SOCK};

  echo 'Creating proxy socket...';
  socat UNIX-LISTEN:${SSH_AUTH_PROXY_SOCK},perm=0666,fork UNIX-CONNECT:${SSH_AUTH_SOCK} &

  echo 'Starting SSH agent...';
  exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -d;
else
	exec "$@"
fi
