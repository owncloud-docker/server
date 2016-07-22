# ownCloud / server

Docker image for ownCloud web server Standard Edition
running on [owncloud/owncloud-base](https://hub.docker.com/r/owncloud/owncloud-base/)
running on [owncloud/ubuntu](https://hub.docker.com/r/owncloud/ubuntu/)

## Image Description

- Ubuntu 16.04 with PHP7
- Caching with APCu and Redis support
- HTTPS access by default with self-signed certs, add your certificates optionally 
- ownCloud installation and updates automatically
- ownCloud logs to docker log
- Large baseimage, so low storage needs for each version
- Data persistence on host with docker volumes
- docker-compose file to easy start full stack or even clustered setup (wip)
- more to come ...


## Usage
### Use Docker Compose

Create and start ownCloud stack

```bash
docker-compose up -d
```

More commands of interest
```bash
docker-compose exec owncloud bash
docker-compose stop
docker-compose start
docker-compose down
```


### Manual Build with script

Building Version 9.0.4, run
```bash
./build.sh 9.0.4
```

Version is optional. Find default version in .env file.
Build script always pulls latest base image.


### Manual Startup

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


### Access ownCloud

https://localhost/

- user: admin
- pass: password	(as set in bin/container-config.sh)

Note: After first startup, ownCloud installs automatically, this takes a few seconds.


## Options and Configurations
### Data Folder persistence on Host

You can just add a volume to the container on startup
See: [Docker Compose Volume Docs](https://docs.docker.com/compose/compose-file/#/volumes-volume-driver)

```bash
docker run -d -ti \
  --name owncloud \
  --link mariadb:mariadb --link redis:redis \
  -p 443:443 \
  -v /yourDataDirectory:/mnt/data \
  owncloud/server
```


### Certificates

Find certificates here
```
SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
```

Add your own certificates to running container with 
```bash
docker cp mycertfile server_owncloud_1:/etc/ssl/certs/ssl-cert.pem
docker cp mycertkeyfile server_owncloud_1:/etc/ssl/private/ssl-cert.key
```

Add your own certificates on build time, append to the Dockerfile
```
ADD mycertfile:/etc/ssl/certs/ssl-cert.pem
ADD mycertkeyfile:/etc/ssl/private/ssl-cert.key 
```


### Port forwarding in compose file

By default Port 80 (HTTP) and 433(HTTPS) are open and forwarded.
If you use a proxy or loadbalancer with ssl offloading, you want to only use Port 80.
Otherwise, you can restrict access to Port 443 for higher security.

Tested with Traefik Proxy and HaProxy Loadbalancer
- https://hub.docker.com/r/webhippie/traefik/
- https://hub.docker.com/r/webhippie/haproxy/


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

- OWNCLOUD_DOMAIN
  - Set your domain to configure trusted domains
- MARIADB_ENV_MARIADB_ROOT_PASSWORD 
  - Password to access DB


## Contributing

Fork -> Patch -> Push -> Pull Request

## Issues, Feedback and Ideas

Open an [Issue](https://github.com/owncloud-docker/server/issues)


## Authors

* [Felix Böhm](https://github.com/felixboehm)


## License

MIT


## Copyright

```
Copyright (c) 2016 Felix Böhm <http://owncloud.org>
```
