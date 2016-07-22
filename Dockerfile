FROM owncloud/owncloud-base:latest

ARG VERSION=9.0.4
ARG OWNCLOUD_TARBALL=https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2

# download ownCloud
RUN curl -sLo - ${OWNCLOUD_TARBALL} | tar xfj - -C /var/www/ \
  && chown -R www-data.www-data /var/www/owncloud
