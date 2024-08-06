# ownCloud: Server

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-docker/server/status.svg)](https://drone.owncloud.com/owncloud-docker/server)
[![Docker Hub](https://img.shields.io/docker/v/owncloud/server?logo=docker&label=dockerhub&sort=semver&logoColor=white)](https://hub.docker.com/r/owncloud/server)
[![GitHub contributors](https://img.shields.io/github/contributors/owncloud-docker/server)](https://github.com/owncloud-docker/server/graphs/contributors)
[![Source: GitHub](https://img.shields.io/badge/source-github-blue.svg?logo=github&logoColor=white)](https://github.com/owncloud-docker/server)
[![License: MIT](https://img.shields.io/github/license/owncloud-docker/server)](https://github.com/owncloud-docker/server/blob/master/LICENSE)

Official [ownCloud](https://owncloud.com) Docker image. It's designed to work with a data volume in the host filesystem and with a standalone MariaDB and Redis container. For a guide how to get started please take a look at our [documentation](https://doc.owncloud.com/server/latest/admin_manual/installation/docker/).

## About ownCloud

ownCloud is an open-source file sync, share and content collaboration software that lets teams work on data easily from anywhere, on any device. It provides access to your data through a web interface, sync clients or WebDAV while providing a platform to view, sync and share across devices easily - all under your control. ownCloud’s open architecture is extensible via a simple but powerful API for applications and plugins and it works with any storage.

![Secure content collaboration and filesharing with ownCloud](https://raw.githubusercontent.com/owncloud-docker/server/master/images/Home-UI.png)

## Quick reference

- **Where to file issues:**\
  [owncloud/core](https://github.com/owncloud/core/issues)

- **Supported architectures:**\
  `amd64`, `arm64v8`

- **Inherited environments:**\
  [owncloud/ubuntu](https://github.com/owncloud-docker/ubuntu#environment-variables),
  [owncloud/php](https://github.com/owncloud-docker/php#environment-variables),
  [owncloud/base](https://github.com/owncloud-docker/base#environment-variables)

## Docker Tags and respective Dockerfile links

- [`10.15.0`](https://github.com/owncloud-docker/server/blob/master/v20.04/Dockerfile.multiarch) available as `owncloud/server:10.15.0`, `owncloud/server:10.15`, `owncloud/server:10`, `owncloud/server:latest`
- [`10.14.0`](https://github.com/owncloud-docker/server/blob/master/v20.04/Dockerfile.multiarch) available as `owncloud/server:10.14.0`,
- [`10.13.4`](https://github.com/owncloud-docker/server/blob/master/v20.04/Dockerfile.multiarch) available as `owncloud/server:10.13.4`, `owncloud/server:10.13`

## Default volumes

- `/mnt/data`

## Exposed ports

- 8080

## Environment variables

None

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/owncloud-docker/server/blob/master/LICENSE) file for details.

## Copyright

```Text
Copyright (c) 2022 ownCloud GmbH
```
