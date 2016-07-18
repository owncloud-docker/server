#!/bin/bash

echo "waiting for DB setup ..."
# Wait for DB to be ready
while ! ping -c1 mariadb &>/dev/null; do :; done
while ! mysql -h mariadb -u root -p$MARIADB_ENV_MARIADB_ROOT_PASSWORD -e "show databases" &>/dev/null; do :; done

# Install ownCloud
occ maintenance:install --database "mysql" --database-name "owncloud"  --database-host "mariadb" --database-user "root" --database-pass "$MARIADB_ENV_MARIADB_ROOT_PASSWORD" --admin-user "admin" --admin-pass "password" --data-dir "/mnt/data"

chmod 0644 /mnt/data/.htaccess
chmod 0644 /var/www/owncloud/.htaccess

# Loglevel 0=Debug 
occ config:system:set loglevel --value 0

[[ -z $OWNCLOUD_DOMAIN ]] && OWNCLOUD_DOMAIN=${HOSTNAME}
IP=$(hostname -i)

# Configure trusted domains
sed -i "s_0 => 'localhost',_0 => 'localhost', 1 => '${OWNCLOUD_DOMAIN}', 2 => '$IP',_" /var/www/owncloud/config/config.php
occ config:system:set overwrite.cli.url --value https://${OWNCLOUD_DOMAIN}

# Caching
occ 'config:system:set memcache.local --value "\OC\Memcache\APCu"'

# Configure Redis 
occ config:system:set redis --value FIXME
sed -i "s_'FIXME'_['host' => 'redis','port' => 6379,'timeout' => 0.0]_" /var/www/owncloud/config/config.php

# switch filelocking on later
occ 'config:system:set memcache.locking --value "\OC\Memcache\Redis"'
occ config:system:set filelocking.enabled --value true


