# ownCloud: Server

[![Build Status](https://github.com/owncloud-docker/server/actions/workflows/main.yml/badge.svg)](https://github.com/owncloud-docker/server/actions/workflows/main.yml)
[![Docker Hub](https://img.shields.io/docker/v/owncloud/server?logo=docker&label=dockerhub&sort=semver&logoColor=white)](https://hub.docker.com/r/owncloud/server)
[![GitHub contributors](https://img.shields.io/github/contributors/owncloud-docker/server)](https://github.com/owncloud-docker/server/graphs/contributors)
[![Source: GitHub](https://img.shields.io/badge/source-github-blue.svg?logo=github&logoColor=white)](https://github.com/owncloud-docker/server)
[![License: MIT](https://img.shields.io/github/license/owncloud-docker/server)](https://github.com/owncloud-docker/server/blob/master/LICENSE)
[![ownCloud OSPO](https://img.shields.io/badge/OSPO-ownCloud-blue)](https://kiteworks.com/opensource)

Official [ownCloud](https://owncloud.com) Docker image. It's designed to work with a data volume in the host filesystem and with a standalone MariaDB and Redis container. For a guide how to get started please take a look at our [documentation](https://doc.owncloud.com/server/latest/admin_manual/installation/docker/).

## About ownCloud

ownCloud is an open-source file sync, share and content collaboration software that lets teams work on data easily from anywhere, on any device. It provides access to your data through a web interface, sync clients or WebDAV while providing a platform to view, sync and share across devices easily - all under your control. ownCloud’s open architecture is extensible via a simple but powerful API for applications and plugins and it works with any storage.

![Secure content collaboration and filesharing with ownCloud](https://raw.githubusercontent.com/owncloud-docker/server/master/images/Home-UI.png)

## Quick reference

- **Where to file issues:**\
  [owncloud/core](https://github.com/owncloud/core/issues)

- **Supported architectures:**\
  `amd64`, `arm64v8`

- **Inherited environments:**\
  [owncloud/ubuntu](https://github.com/owncloud-docker/ubuntu#environment-variables),
  [owncloud/php](https://github.com/owncloud-docker/php#environment-variables),
  [owncloud/base](https://github.com/owncloud-docker/base#environment-variables)

## Docker Tags and respective Dockerfile links

- [`10.16.3`, `10.16`, `10`, `latest`](https://github.com/owncloud-docker/server/blob/master/v22.04/Dockerfile.multiarch) available as `owncloud/server:10.16.3`
- [`11.0.0-prealpha`](https://github.com/owncloud-docker/server/blob/master/v24.04/Dockerfile.multiarch) available as `owncloud/server:11.0.0-prealpha`

## Default volumes

- `/mnt/data`

## Exposed ports

- 8080

## Running occ commands

Starting with `11.0.0-prealpha`, the image supports running any `occ` command
with full initialization (database, config, etc.) but without starting Apache,
by using the `occ` subcommand in `docker-compose.yml`:

```yaml
command: ["/usr/bin/owncloud", "occ", "<occ-command>", "<args...>"]
```

Example — start the Windows Network Drive SMB listener:

```yaml
command: ["/usr/bin/owncloud", "occ", "wnd:listen", "myhost", "myshare", "myuser", "--password-file=/run/secrets/wnd_password"]
```

## Environment variables

This image defines no environment variables of its own. Configuration is done
through the variables inherited from the base images linked under
[Inherited environments](#quick-reference) above.

## Community & Support

- [ownCloud Website](https://owncloud.com)
- [Community Discussions](https://github.com/orgs/owncloud/discussions)
- [Matrix Chat](https://app.element.io/#/room/#owncloud:matrix.org)
- [Documentation](https://doc.owncloud.com)
- [Enterprise Support](https://owncloud.com/contact-us/)
- [OSPO Home](https://kiteworks.com/opensource)

See [SUPPORT.md](SUPPORT.md) for the full list of support channels.

## Contributing

We welcome contributions! Please read the [Contributing Guidelines](CONTRIBUTING.md)
and our [Code of Conduct](CODE_OF_CONDUCT.md) before getting started.

- **Rebase Early, Rebase Often!** We use a rebase workflow — rebase on the target
  branch before submitting a PR.
- **Signed commits**: All commits **must** be PGP/GPG signed and carry a DCO
  `Signed-off-by` line (`git commit -S -s`).
- **Conventional Commits**: PR titles must follow the
  [Conventional Commits](https://www.conventionalcommits.org/) format — enforced
  by CI.
- **GitHub Actions Policy**: Workflows may only use actions owned by `owncloud`,
  created by GitHub (`actions/*`), or verified in the GitHub Marketplace, pinned
  to a full commit SHA.

## Security

**Do not open a public GitHub issue for security vulnerabilities.**

Report vulnerabilities at **<https://security.owncloud.com>** — see [SECURITY.md](SECURITY.md).

Bug bounty: [YesWeHack ownCloud Program](https://yeswehack.com/programs/owncloud-bug-bounty-program)

## About the ownCloud OSPO

The [Kiteworks Open Source Program Office](https://kiteworks.com/opensource), operating under
the [ownCloud](https://owncloud.com) brand, launched on May 5, 2026, to steward the open source
ecosystem around ownCloud's products. The OSPO ensures transparent governance, license compliance,
community health, and sustainable collaboration between the open source community and
[Kiteworks](https://www.kiteworks.com), which acquired ownCloud in 2023.

- **OSPO Home**: <https://kiteworks.com/opensource>
- **GitHub**: <https://github.com/owncloud>
- **ownCloud**: <https://owncloud.com>

For questions about the OSPO or licensing, contact ospo@kiteworks.com.

This repository is licensed under the permissive **MIT License**, which is already
compatible with the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)
that the OSPO is adopting across the ecosystem. No relicensing or copyleft
dependency audit is required.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/owncloud-docker/server/blob/master/LICENSE) file for details.

## Copyright

```Text
Copyright (c) 2022-2026 ownCloud GmbH
```
