FROM owncloud/owncloud-base:latest

ARG VERSION=9.0.4
ARG OWNCLOUD_TARBALL=https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2
ARG APP_TARBALL=https://github.com/owncloud/richdocuments/releases/download/1.1.3/richdocuments.tar.gz

# download ownCloud
RUN curl -sLo - ${OWNCLOUD_TARBALL} | tar xfj - -C /var/www/ \
  && chown -R www-data.www-data /var/www/owncloud

RUN curl -sLo - ${APP_TARBALL} | tar xfz - -C /var/www/owncloud/apps/ \
  && chown -R www-data.www-data /var/www/owncloud/apps