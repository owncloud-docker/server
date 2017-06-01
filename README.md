# ownCloud: Server

[![](https://images.microbadger.com/badges/image/owncloud/server.svg)](https://microbadger.com/images/owncloud/server "Get your own image badge on microbadger.com")

This is the official ownCloud image for the community edition, it is built from our [base container](https://registry.hub.docker.com/u/owncloud/base/). This ownCloud image is designed to work with a data volume in the host filesystem and with separate MariaDB and Redis containers.


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


## Usage

```bash
docker run -ti \
  --name owncloud \
  owncloud/server:latest
```


### Launch with plain `docker`

The installation of `docker` is not covered by this instructions, please follow the [official installation instructions](https://docs.docker.com/engine/installation/). After the installation of docker you can continue with the required MariaDB and Redis containers:

```bash
docker run -d \
  --name redis \
  webhippie/redis:latest

docker run -d \
  --name mariadb \
  -e MARIADB_ROOT_PASSWORD=owncloud \
  -e MARIADB_USERNAME=owncloud \
  -e MARIADB_PASSWORD=owncloud \
  -e MARIADB_DATABASE=owncloud \
  --volume ./mysql:/var/lib/mysql \
  webhippie/mariadb:latest
```

Then you can start the ownCloud web server, you can customize the used environment variables as needed:

```bash
export OWNCLOUD_VERSION=10.0.2 # The ownCloud version to launch
export OWNCLOUD_DOMAIN=localhost
export OWNCLOUD_ADMIN_USERNAME=admin
export OWNCLOUD_ADMIN_PASSWORD=admin
export OWNCLOUD_HTTP_PORT=80
export OWNCLOUD_HTTPS_PORT=443

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
  --volume ./data:/mnt/data:z \
  owncloud/server:${OWNCLOUD_VERSION}
```


### Launch with `docker-compose`

The installation of `docker-compose` is not covered by these instructions, please follow the [official installation instructions](https://docs.docker.com/compose/install/). After the installation of `docker-compose` you can continue with the following commands to start the ownCloud stack. First we are defining some required environment variables, then we are downloading the required `docker-compose.yml` file. The `.env` and `docker-compose.yml` are expected in the current working directory, when running `docker-compose` commands:

```bash
cat << EOF > .env
VERSION=10.0.2 # The ownCloud version to launch
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

By default `docker-compose up` will start Redis, MariaDB and ownCloud containers, the `./data` and `./mysql` directories are used to store the contents persistently. The container ports `80` and `443` are bound as configured in the `.env` file.


### Upgrade to newer version

In order to upgrade an existing container-based installation you just need to shutdown the setup and replace the used container version. While booting the containers the upgrade process gets automatically triggered, so you don't need to perform any other manual step.


### Custom apps

Installed apps or config.php changes inside the docker container are retained across stop/start as long as you keep the volumes configured.


### Custom certificates

By default we generate self-signed certificates on startup of the containers, you can replace the certificates with your own certificates. Place them into `./data/certs/ssl-cert.crt` and `./data/certs/ssl-cert.key`.


### Accessing the ownCloud

By default you can access the ownCloud instance at [https://localhost/](https://localhost/) as long as you have not changed the port binding. The initial user gets set by the environment variables `ADMIN_USERNAME` and `ADMIN_PASSWORD`, per default it's set to `admin` for username and password.


## Build locally

The available versions should be already pushed to the Docker Hub, but in case you want to try a change locally you can always execute the following command (run from a cloned GitHub repository) to get an image built locally:

```
source .env
IMAGE_NAME=owncloud/server:${VERSION} ./hooks/build
```


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
