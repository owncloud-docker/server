# Scenarios of ownCloud core 11.0.1's acceptance tests that are expected to fail against this
# image (smoke run). run.sh fails the job on any other failure, and on a listed
# scenario that passes. One entry per line, as in core's own lists:
# `- [apiSuite/file.feature:12](https://github.com/owncloud/core/blob/master/tests/acceptance/features/apiSuite/file.feature#L12)`

## CLI

# Found in this repository's CI; they depend on how the image is set up.
- [cliMain/configKey.feature:101](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliMain/configKey.feature#L101)
- [cliManageApps/appsPath.feature:18](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliManageApps/appsPath.feature#L18)
- [cliManageApps/appsPath.feature:36](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliManageApps/appsPath.feature#L36)
- [cliManageApps/appsPath.feature:47](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliManageApps/appsPath.feature#L47)
- [cliProvisioning/resetUserPassword.feature:19](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliProvisioning/resetUserPassword.feature#L19)
- [cliProvisioning/resetUserPasswordOc10Issue36985.feature:8](https://github.com/owncloud/core/blob/master/tests/acceptance/features/cliProvisioning/resetUserPasswordOc10Issue36985.feature#L8)
