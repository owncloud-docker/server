

- You don't use data persistence. There are no volumes which hold data over the existence of the container. Checking for existing configs is yet marked as open issue. Data persistence is an issue with our idea of installation, since we want to use a docker swarm approach with multiple oc instances. So I have to make sure, that they all use the same config and have access to the same data volumes. Most of the files will be stored in our S3, so this is not a problem, but afaik there might be some apps, which still store their data on the filesystem.

- The sources are fetched during build time. Is there a way of getting the enterprise version in a similar, automated, way? Like pulling from GitHub or fetching the tarball with username/password somewhere? The enterprise version of your docker image uses a local tarball to install.


I am trying to setup OC-EE in a dockerized environment.
Due to performance reasons I want to make as many files/paths static within the container.
- Data-Dir: this has to be mounted externaly, OK. And we are also using S3 backend for data storage.
- Config-Dir: we want to create our config and put it static into the container. If we dont change anything during runtime, this is fine.
- Misc-Configs in Misc Files: but there are some config settings, which are not written to config dir, data dir or database. PHP upload size is such a parameter, which gets written to .htaccess. During an update/re-build of container, this file will be overwritten by the oc-sources.

But this is not just a problem occuring with containers, since any update would overwrite .htaccess anyway.

Is there an overview of files and locations, where configuration might happen?

Thanks, Chris



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

### Data Folder persistence on Host

Add a Volume to the container
See: [Docker Compose Volume Docs](https://docs.docker.com/compose/compose-file/#/volumes-volume-driver)

```bash
docker run -d -ti \
  --name owncloud \
  --link mariadb:mariadb --link redis:redis \
  -p 443:443 \
  -v /yourDataDirectory:/mnt/data \
  owncloud/server
```

## Versions

### Testing
* [9.1.0RC4](https://github.com/owncloud-docker/server/tree/9.1.0RC3)
  available as ```owncloud/server:9.1.0RC3``` at [Docker Hub](https://hub.docker.com/r/owncloud/ubuntu/)

### Stable
* [latest](https://github.com/owncloud-docker/server/tree/master)
  available as ```owncloud/server:latest``` at [Docker Hub](https://hub.docker.com/r/owncloud/ubuntu/)
* [9.0.4](https://github.com/owncloud-docker/server/tree/9.0.4)
  available as ```owncloud/server:9.0.3``` at [Docker Hub](https://hub.docker.com/r/owncloud/ubuntu/)
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
