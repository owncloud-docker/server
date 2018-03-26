# ownCloud: Server

[![](https://images.microbadger.com/badges/image/owncloud/server.svg)](https://microbadger.com/images/owncloud/server "Get your own image badge on microbadger.com")

This is the official ownCloud image for the community edition, it is built from our [base container](https://registry.hub.docker.com/u/owncloud/base/). This ownCloud image is designed to work with a data volume in the host filesystem and with separate MariaDB and Redis containers.

[![Try in PWD](https://cdn.rawgit.com/play-with-docker/stacks/cff22438/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/owncloud-docker/server/master/docker-compose.yml)

## Versions

To get an overview about the available versions please take a look at the [GitHub branches](https://github.com/owncloud-docker/server/branches/all) or our [Docker Hub tags](https://hub.docker.com/r/owncloud/server/tags/), these lists are always up to date. Please note that release candidates or alpha/beta versions are only temporary available, they will be removed after the final release of a version.


## Volumes

* /mnt/data


## Ports

* 80
* 443

## Available environment variables

```

```

## Inherited environment variables

* [owncloud/base](https://github.com/owncloud-docker/base#available-environment-variables)
* [owncloud/ubuntu](https://github.com/owncloud-docker/ubuntu#available-environment-variables)


## Build locally

The available versions should be already pushed to the Docker Hub, but in case you want to try a change locally you can always execute the following command (run from a cloned GitHub repository) to get an image built locally:

```
source .env
IMAGE_NAME=owncloud/server:${VERSION} ./hooks/build
```


### Launch with plain `docker`

The installation of `docker` is not covered by this instructions, please follow the [official installation instructions](https://docs.docker.com/engine/installation/). After the installation of docker you can continue with the required MariaDB and Redis containers:

```bash
docker volume create owncloud_redis

docker run -d \
  --name redis \
  -e REDIS_DATABASES=1 \
  --volume owncloud_redis:/var/lib/redis \
  webhippie/redis:latest

docker volume create owncloud_mysql
docker volume create owncloud_backup

docker run -d \
  --name mariadb \
  -e MARIADB_ROOT_PASSWORD=owncloud \
  -e MARIADB_USERNAME=owncloud \
  -e MARIADB_PASSWORD=owncloud \
  -e MARIADB_DATABASE=owncloud \
  --volume owncloud_mysql:/var/lib/mysql \
  --volume owncloud_backup:/var/lib/backup \
  webhippie/mariadb:latest
```

Then you can start the ownCloud web server, you can customize the used environment variables as needed, for the ownCloud version you can choose any of the available tags:

```bash
export OWNCLOUD_VERSION=10.0
export OWNCLOUD_DOMAIN=localhost
export OWNCLOUD_ADMIN_USERNAME=admin
export OWNCLOUD_ADMIN_PASSWORD=admin
export OWNCLOUD_HTTP_PORT=80
export OWNCLOUD_HTTPS_PORT=443

docker volume create owncloud_files

docker run -d \
  --name owncloud \
  --link mariadb:db \
  --link redis:redis \
  -p 80:80 \
  -p 443:443 \
  -e OWNCLOUD_DOMAIN=${OWNCLOUD_DOMAIN} \
  -e OWNCLOUD_DB_TYPE=mysql \
  -e OWNCLOUD_DB_NAME=owncloud \
  -e OWNCLOUD_DB_USERNAME=owncloud \
  -e OWNCLOUD_DB_PASSWORD=owncloud \
  -e OWNCLOUD_DB_HOST=db \
  -e OWNCLOUD_ADMIN_USERNAME=${OWNCLOUD_ADMIN_USERNAME} \
  -e OWNCLOUD_ADMIN_PASSWORD=${OWNCLOUD_ADMIN_PASSWORD} \
  -e OWNCLOUD_REDIS_ENABLED=true \
  -e OWNCLOUD_REDIS_HOST=redis \
  --volume owncloud_files:/mnt/data \
  owncloud/server:${OWNCLOUD_VERSION}
```


### Launch with `docker-compose`

The installation of `docker-compose` is not covered by these instructions, please follow the [official installation instructions](https://docs.docker.com/compose/install/). After the installation of `docker-compose` you can continue with the following commands to start the ownCloud stack. First we are defining some required environment variables, then we are downloading the required `docker-compose.yml` file. The `.env` and `docker-compose.yml` are expected in the current working directory, when running `docker-compose` commands, for the ownCloud version you can choose any of the available tags:

```bash
cat << EOF > .env
VERSION=10.0
DOMAIN=localhost
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin
HTTP_PORT=80
HTTPS_PORT=443
EOF

wget -O docker-compose.yml https://raw.githubusercontent.com/owncloud-docker/server/master/docker-compose.yml

# Finally start the containers in the background
docker-compose up -d
```

More commands of interest (try adding `-h` for help):

```bash
docker-compose exec owncloud bash
docker-compose stop
docker-compose start
docker-compose down
docker-compose logs
```

By default `docker-compose up` will start Redis, MariaDB and ownCloud containers, the content gets stored in named volumes persistently. The container ports `80` and `443` are bound as configured in the `.env` file.

### Commandline commands

You can run `occ` commands inside the ownCloud docker image, without caring for sudo and apache user, as the command is wrapped in a little script caring for that. Just run:

```
occ user:report
```

You can also run commands via `docker exec`, or `docker-compse exec`:

```
docker exec -ti example_owncloud_1 occ user:report
docker-compose exec owncloud occ user:report
```

### Upgrade to newer version

In order to upgrade an existing container-based installation you just need to shutdown the setup and replace the used container version. While booting the containers the upgrade process gets automatically triggered, so you don't need to perform any other manual step.


### Custom apps

Installed apps or config.php changes inside the docker container are retained across stop/start as long as you keep the volumes configured.


### Custom certificates

By default we generate self-signed certificates on startup of the containers, you can replace the certificates with your own certificates. You can use `docker cp` to place them into the directory, e.g. `docker cp ssl-cert.crt $(docker-compose ps -q owncloud):/mnt/data/certs/` and `docker cp ssl-cert.key $(docker-compose ps -q owncloud):/mnt/data/certs/`.


### Accessing the ownCloud

By default you can access the ownCloud instance at [https://localhost/](https://localhost/) as long as you have not changed the port binding. The initial user gets set by the environment variables `ADMIN_USERNAME` and `ADMIN_PASSWORD`, per default it's set to `admin` for username and password.


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
Copyright (c) 2017 Thomas Boerger <tboerger@owncloud.com>
```
