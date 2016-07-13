#!/bin/bash

# Start apache
service apache2 start

touch /mnt/data/owncloud.log
tail -F /mnt/data/owncloud.log