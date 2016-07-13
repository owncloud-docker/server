#!/bin/bash

# Start apache
service apache2 start

su www-data -s /bin/bash -c "touch /mnt/data/owncloud.log"
tail -F /mnt/data/owncloud.log