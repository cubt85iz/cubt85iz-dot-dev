---
title: 'Audiobookshelf'
comments: false
date: 2025-04-15T10:34:59-04:00
draft: true
weight: 10
---
## Overview

## Configuration

### Image

To use audiobookshelf, it needs to be included in your generated image. Update your build configuration to include it.

```json {filename=".config/my-server-build"}
{
  "containers": [
    "audiobookshelf"
  ]
}
```

### Service

```systemd {base_url="https://github.com/cubt85iz/automatos-server/blob/main", filename="/etc/containers/systemd/audiobookshelf.container"}
[Unit]
Description=Container service for Audiobookshelf
Requires=network-online.target nss-lookup.target
After=network-online.target nss-lookup.target

[Container]
ContainerName=%p
Image=docker.io/advplyr/audiobookshelf:latest
Volume=${CONTAINER_PATH}/config:/config:Z
Volume=${CONTAINER_PATH}/metadata:/metadata:Z
PublishPort=${WEB_PORT}:80
AutoUpdate=registry

[Service]
EnvironmentFile=/etc/environment
ExecCondition=/usr/bin/test -d "${CONTAINER_PATH}/config"
ExecCondition=/usr/bin/test -d "${CONTAINER_PATH}/metadata"
Restart=on-failure

[Install]
WantedBy=default.target
```

### Customizations

```systemd {filename="/etc/containers/systemd/audiobookshelf.container.d/01-variables.conf"}
[Container]
Environment=AUDIOBOOKSHELF_GID=1000
Environment=AUDIOBOOKSHELF_UID=1000

[Service]
Environment=CONTAINER_PATH=/var/path/to/path/for/audiobookshelf/files
Environment=WEB_PORT=80
```

```systemd {filename="/etc/containers/sytemd/audiobookshelf.container.d/02-volumes.conf"}
[Container]
Volume=/var/path/to/audiobooks:/audiobooks:z,rw,rslave,rbind
```

> [!TIP]
> The values shown above are notional. Customize these values to suit your needs.
