# Scenarios of ownCloud core 11.0.1's acceptance tests that are expected to fail against this
# image (smoke run). run.sh fails the job on any other failure, and on a listed
# scenario that passes. One entry per line, as in core's own lists:
# - [apiSuite/file.feature:12](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiSuite/file.feature#L12)

## CLI

# Found in this repository's CI. cliExternalStorage needs a second ownCloud server
# to mount over WebDAV; the others depend on how the image is set up.
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:107](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L107)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:128](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L128)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:150](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L150)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:212](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L212)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:232](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L232)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:273](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L273)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:382](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L382)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:67](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L67)
- [cliExternalStorage/filesExternalWebdavOwncloud.feature:86](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliExternalStorage/filesExternalWebdavOwncloud.feature#L86)
- [cliMain/configKey.feature:101](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliMain/configKey.feature#L101)
- [cliManageApps/appsPath.feature:18](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliManageApps/appsPath.feature#L18)
- [cliManageApps/appsPath.feature:36](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliManageApps/appsPath.feature#L36)
- [cliManageApps/appsPath.feature:47](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliManageApps/appsPath.feature#L47)
- [cliProvisioning/resetUserPassword.feature:19](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliProvisioning/resetUserPassword.feature#L19)
- [cliProvisioning/resetUserPasswordOc10Issue36985.feature:8](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliProvisioning/resetUserPasswordOc10Issue36985.feature#L8)
