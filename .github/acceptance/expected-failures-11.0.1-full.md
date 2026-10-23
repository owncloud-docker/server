# Scenarios of ownCloud core 11.0.1's acceptance tests that are expected to fail against this
# image (full run). run.sh fails the job on any other failure, and on a listed
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

## API

# From local full runs: these failed in the suite and fail again on their own against
# the published image. Check them against the first full run in CI.
- [apiMain/appManagement.feature:16](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiMain/appManagement.feature#L16)
- [apiMain/appManagement.feature:28](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiMain/appManagement.feature#L28)
- [apiMain/appManagement.feature:40](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiMain/appManagement.feature#L40)
- [apiMain/appManagement.feature:52](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiMain/appManagement.feature#L52)
- [apiMain/external-storage.feature:65](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiMain/external-storage.feature#L65)
- [apiShareManagementBasicToRoot/createShareFromLocalStorageToRootFolder.feature:109](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToRoot/createShareFromLocalStorageToRootFolder.feature#L109)
- [apiShareManagementBasicToRoot/createShareFromLocalStorageToRootFolder.feature:57](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToRoot/createShareFromLocalStorageToRootFolder.feature#L57)
- [apiShareManagementBasicToRoot/createShareFromLocalStorageToRootFolder.feature:83](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToRoot/createShareFromLocalStorageToRootFolder.feature#L83)
- [apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature:113](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature#L113)
- [apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature:114](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature#L114)
- [apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature:62](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature#L62)
- [apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature:87](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature#L87)
- [apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature:88](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementBasicToShares/createShareFromLocalStorageToSharesFolder.feature#L88)
- [apiShareManagementToRoot/moveReceivedShareFromLocalStorage.feature:40](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementToRoot/moveReceivedShareFromLocalStorage.feature#L40)
- [apiShareManagementToRoot/moveReceivedShareFromLocalStorage.feature:63](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementToRoot/moveReceivedShareFromLocalStorage.feature#L63)
- [apiShareManagementToRoot/moveReceivedShareFromLocalStorage.feature:64](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementToRoot/moveReceivedShareFromLocalStorage.feature#L64)
- [apiShareManagementToShares/moveReceivedShareFromLocalStorage.feature:44](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementToShares/moveReceivedShareFromLocalStorage.feature#L44)
- [apiShareManagementToShares/moveReceivedShareFromLocalStorage.feature:68](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementToShares/moveReceivedShareFromLocalStorage.feature#L68)
- [apiShareManagementToShares/moveReceivedShareFromLocalStorage.feature:89](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiShareManagementToShares/moveReceivedShareFromLocalStorage.feature#L89)
- [apiTrashbinRestore/trashbinRestore.feature:171](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiTrashbinRestore/trashbinRestore.feature#L171)
