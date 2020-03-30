# SSH agent

SSH agent docker container image.

## Environment Variables

| Variable | Default Value
| --- | ---
| **Server**
| `SOCKET_DIR` | `/.ssh-agent`
| `SSH_AUTH_SOCK` | `/.ssh-agent/socket`
| `SSH_AUTH_PROXY_SOCK` | `/.ssh-agent/proxy-socket`
| `SSH_DIR` | `/.ssh`
| `SSH_KEYS_DIR` | `/.ssh-keys`

## Docker usage

### Start the SSH container

```sh
docker run \
    -d \
    --name=sshagent \
    liip/ssh-agent:1.0.0
```

### Add a SSH key

Replace `SSH_DIR` and `KEY` accordingly. If the key has a passphrase, you will be prompted to enter it.
```sh
SSH_DIR=~/.ssh
KEY=id_rsa
docker run \
    --rm \
    --volumes-from=sshagent \
    -v ${SSH_DIR}/${KEY}:/.ssh/${KEY} \
    -it \
    sshagent \
    ssh-key add ${KEY}
```

### Remove a SSH key

Replace `KEY` accordingly.
```sh
KEY=id_rsa
docker run \
    --rm \
    --volumes-from=sshagent \
    -it \
    sshagent \
    ssh-key remove ${KEY}
```

### Remove all SSH keys

```sh
docker run \
    --rm \
    --volumes-from=sshagent \
    -it \
    sshagent \
    ssh-key remove-all
```

### List SSH keys

```sh
docker run \
    --rm \
    --volumes-from=sshagent \
    -it \
    sshagent \
    ssh-key list
```

### Forward SSH Agent

```sh
docker run \
    --rm \
    --volumes-from=sshagent \
    -e SSH_AUTH_SOCK=/.ssh-agent/proxy-socket
    -it \
    <image> ssh-add -l
```

## Docker compose usage

### Start the SSH container

```dotenv
COMPOSE_COMPOSE_PROJECT_NAME=sshagent
```

```yaml
version: '3.5'
services:
  agent:
    image: liip/ssh-agent:1.0.0
    restart: unless-stopped
    volumes:
      - socket_dir:/.ssh-agent
      - ssh_keys_dir:/.ssh-keys

  add:
    image: liip/ssh-agent:1.0.0
    depends_on:
      - agent
    command:
      - ssh-add
    environment:
      SSH_AUTH_SOCK: /.ssh-agent/proxy-socket
    volumes:
      - socket_dir:/.ssh-agent
      - ssh_keys_dir:/.ssh-keys

volumes:
  socket_dir:
  ssh_keys_dir:
```

### Add a SSH key

Replace `SSH_DIR` and `KEY` accordingly. If the key has a passphrase, you will be prompted to enter it.
```sh
SSH_DIR=~/.ssh
KEY=id_rsa
docker run \
    --rm \
    --volumes-from=sshagent_agent \
    -v ${SSH_DIR}/${KEY}:/.ssh/${KEY} \
    -it \
    liip/ssh-agent:1.0.0 \
    ssh-key add ${KEY}
```

### Remove a SSH key

Replace `KEY` accordingly.
```sh
KEY=id_rsa
docker run \
    --rm \
    --volumes-from=sshagent_agent \
    -it \
    liip/ssh-agent:1.0.0 \
    ssh-key remove ${KEY}
```

### Remove all SSH keys

```sh
docker run \
    --rm \
    --volumes-from=sshagent_agent \
    -it \
    liip/ssh-agent:1.0.0 \
    ssh-key remove-all
```

### List SSH keys

```sh
docker run \
    --rm \
    --volumes-from=sshagent_agent \
    -it \
    liip/ssh-agent:1.0.0 \
    ssh-key list
```

### Forward SSH Agent

```yaml
services:
  service_name:
    ...
    environment:
        SSH_AUTH_SOCK: /.ssh-agent/proxy-socket
    ...
    volumes:
        - ssh_agent_socket_dir:/.ssh-agent
...
volumes:
    ssh_agent_socket_dir:
        external: true
```
