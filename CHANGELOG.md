# Changelog

## 2025-04-29

* Changed
  * Use ubuntu-22.04 with Freexian PHP 7.4 with owncloud-complete-20250311 10.15.2

## 2020-05-25

* Added
  * Add ubuntu-20.04 for owncloud-complete-10.5.0beta1

## 2019-10-16

* Changed
  * Switch to single branch development
  * Use drone starlark instead of yaml
  * Prepare multi architecture support

## 2019-07-29

* Added
  * Link to documentation for installation
* Removed
  * Drop docker and docker-compose examples

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
