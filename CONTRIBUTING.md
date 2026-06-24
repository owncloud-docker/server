# Contributing

Thank you for your interest in contributing to this project!

Please read the full contributing guidelines at:
**<https://owncloud.com/contribute/>**

## About this repository

This repository builds the official **ownCloud Classic** Docker image. It is not
the ownCloud Classic source code — it packages a release tarball on top of the
[`owncloud/base`](https://github.com/owncloud-docker/base) image. See the
[README](README.md) for build details, supported tags and usage.

## Pull requests

- **Rebase Early, Rebase Often!** We use a rebase workflow. Rebase on the target
  branch before submitting a PR; do not create merge commits.
- **Signed commits**: All commits **must** be PGP/GPG signed. See
  [GitHub's signing guide](https://docs.github.com/en/authentication/managing-commit-signature-verification).
- **DCO Sign-off**: Every commit must carry a `Signed-off-by` line:
  ```
  git commit -S -s -m "your commit message"
  ```
- **Conventional Commits**: PR titles must follow the
  [Conventional Commits](https://www.conventionalcommits.org/) format — this is
  enforced by CI, and the PR title becomes the squash-merge commit message.
- **GitHub Actions Policy**: Workflows may only use actions that are (a) owned by
  `owncloud`, (b) created by GitHub (`actions/*`), or (c) verified in the GitHub
  Marketplace. Pin all actions to their full commit SHA.
