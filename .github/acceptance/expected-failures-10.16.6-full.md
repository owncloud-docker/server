# Scenarios of ownCloud core 10.16.6's acceptance tests that are expected to fail against this
# image (full run). run.sh fails the job on any other failure, and on a listed
# scenario that passes. One entry per line, as in core's own lists:
# `- [apiSuite/file.feature:12](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiSuite/file.feature#L12)`

## CLI

# Found in this repository's CI; they depend on how the image is set up.
# 10.16-only: this feature is gone from core's master, so its master link is a 404;
# the scenario is in the v10.16.6 tag.
- [cliDbConversion/dbConversion.feature:30](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliDbConversion/dbConversion.feature#L30)
- [cliMain/configKey.feature:81](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliMain/configKey.feature#L81)
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
- [apiWebdavMove1/moveFileAsync.feature:266](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiWebdavMove1/moveFileAsync.feature#L266)
- [apiWebdavPreviews/previews.feature:281](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiWebdavPreviews/previews.feature#L281)
