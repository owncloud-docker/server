# ownCloud / server

Docker image for ownCloud web server running on
[owncloud/ubuntu image](https://hub.docker.com/r/owncloud/ubuntu/).


## Usage

### Use docker-compose

Create and start ownCloud stack

```bash
docker-compose up -d
```

Install ownCloud

```bash
docker-compose exec owncloud owncloud-config.sh
```

### Manual startup

Needs DB and Redis, you can start these with:

```bash
docker run -d --name redis -e REDIS_OPTS="--protected-mode no" webhippie/redis:latest
docker run -d --name mariadb -e MARIADB_ROOT_PASSWORD=secret webhippie/mariadb:latest
```

Then start ownCloud web server:

```bash
docker run -d -ti \
  --name owncloud \
  --link mariadb:mariadb --link redis:redis \
  -p 443:443 \
  owncloud/server
```

For automatic installation run:

```bash
docker exec -ti owncloud owncloud-config.sh
```

### Access ownCloud

https://localhost/

- user: admin
- pass: password	(as set in bin/container-config.sh)


## Versions

### Testing
* [9.1.0RC2](https://github.com/owncloud-docker/server/tree/9.1.0RC2)
  available as ```owncloud/server:9.1.0RC2``` at [Docker Hub](https://hub.docker.com/r/owncloud/ubuntu/)

### Stable
* [latest](https://github.com/owncloud-docker/server/tree/master)
  available as ```owncloud/server:latest``` at [Docker Hub](https://hub.docker.com/r/owncloud/ubuntu/)
* [9.0.3](https://github.com/owncloud-docker/server/tree/9.0.3)
  available as ```owncloud/server:9.0.3``` at [Docker Hub](https://hub.docker.com/r/owncloud/ubuntu/)


## Available environment variables

- none

## Inherited environment variables

- none


## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Felix Böhm](https://github.com/felixboehm)


## License

MIT


## Copyright

```
Copyright (c) 2016 Felix Böhm <http://owncloud.org>
```
