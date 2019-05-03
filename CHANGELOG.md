# Changelog

## 2018-10-09

* Changed
  * Prepare for new `owncloud/base` image
  * Changed port from `80` to `8080`
  * Renamed utf8mb4 env variable to new name
* Removed
  * Dropped port `443`, use a reverse proxy for SSL

## 2018-10-01

* Added
  * Integrate clair vuln checks
* Changed
  * Upgrade ownCloud from 10.0.9 to 10.0.10
  * Switch base image from xenial to bionic
* Removed
  * Dropped matrix builds
