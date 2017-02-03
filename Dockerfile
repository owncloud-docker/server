FROM owncloud/base:latest
MAINTAINER ownCloud DevOps <devops@owncloud.com>

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

ARG TARBALL
ARG RICHDOCUMENTS

RUN curl -sLo - ${TARBALL} | tar xfj - -C /var/www/ && \
  chown -R www-data:www-data /var/www/owncloud

#ADD owncloud-${VERSION}.tar.bz2 /var/www/
#RUN chown -R www-data:www-data /var/www/owncloud

RUN curl -sLo - ${RICHDOCUMENTS} | tar xfz - -C /var/www/owncloud/apps/ && \
  mv /var/www/owncloud/apps/richdocuments-* /var/www/owncloud/apps/richdocuments && \
  chown -R www-data:www-data /var/www/owncloud/apps

LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url="https://github.com/owncloud-docker/community.git"
LABEL org.label-schema.name="ownCloud Community"
LABEL org.label-schema.vendor="ownCloud GmbH"
LABEL org.label-schema.schema-version="1.0"
