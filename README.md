# ownCloud: Server

[![Build Status](https://cloud.drone.io/api/badges/owncloud-docker/server/status.svg)](https://cloud.drone.io/owncloud-docker/server)
[![](https://images.microbadger.com/badges/image/owncloud/server.svg)](https://microbadger.com/images/owncloud/server "Get your own image badge on microbadger.com")

This is the official ownCloud image for the community edition, it is built from our [base container](https://registry.hub.docker.com/u/owncloud/base/). This ownCloud image is designed to work with a data volume in the host filesystem and with separate MariaDB and Redis containers.

For a guide how to get started with this Docker image please take a look at our [official documentation](https://doc.owncloud.com/server/latest/admin_manual/installation/docker/).

## Versions

* `latest` available as `owncloud/server:latest`
* `10.3.0` available as `owncloud/server:10.3.0`, `owncloud/server:10.3`,  `owncloud/server:10`
* `10.2.1` available as `owncloud/server:10.2.1`, `owncloud/server:10.2`
* `10.2.0` available as `owncloud/server:10.2.0`

## Volumes

* /mnt/data

## Ports

* 8080

## Available environment variables

```

```

## Inherited environment variables

* [owncloud/base](https://github.com/owncloud-docker/base#available-environment-variables)
* [owncloud/php](https://github.com/owncloud-docker/php#available-environment-variables)
* [owncloud/ubuntu](https://github.com/owncloud-docker/ubuntu#available-environment-variables)

## Issues, Feedback and Ideas

Open an [Issue](https://github.com/owncloud-docker/server/issues)

## Contributing

Fork -> Patch -> Push -> Pull Request

## Authors

* [Thomas Boerger](https://github.com/tboerger)
* [Felix Boehm](https://github.com/felixboehm)

## License

MIT

## Copyright

```
Copyright (c) 2018 Thomas Boerger <tboerger@owncloud.com>
```
