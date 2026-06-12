# agents.md — server

## Repository Overview

This repository builds the official **ownCloud Server** Docker image
(`owncloud/server` on Docker Hub). It does not contain the ownCloud Server
source code — it packages a release tarball on top of the
[`owncloud/base`](https://github.com/owncloud-docker/base) image and adds an
optional root-filesystem overlay. Images are multi-architecture and built via
GitHub Actions.

- **Classification:** Docker image build
- **Activity Status:** Active
- **License:** MIT
- **Language:** Dockerfile, Shell

## Architecture & Key Paths

- `v22.04/` — Ubuntu 22.04 based image (ownCloud 10.x stable)
  - `v22.04/Dockerfile.multiarch` — image definition (`FROM owncloud/base:22.04`)
  - `v22.04/overlay/` — files copied into the image root (`ADD overlay /`); currently empty
  - `v22.04/<version>/.trivyignore` — accepted-CVE exclusions for the Trivy scan
- `v24.04/` — Ubuntu 24.04 based image (ownCloud 11.0.0-prealpha)
  - `v24.04/Dockerfile.multiarch`, `v24.04/overlay/`, `v24.04/<version>/.trivyignore` — as above
- `docs/` — design/spec notes
- `images/` — README screenshots
- `.github/workflows/main.yml` — **active** CI (build, smoke test, scan, publish)
- `.github/workflows/lint-pr-title.yml` — Conventional-Commit PR-title enforcement
- `.github/dependabot.yml` — weekly GitHub Actions dependency updates
- `.drone.star` — **legacy** Drone CI config (inactive; superseded by GitHub Actions)
- `.renovaterc.json` — Renovate preset for Docker digest updates
- `.editorconfig` — formatting rules (2-space indent, LF, trailing newline)
- `CHANGELOG.md` — flat, date-based changelog at repo root
- `LICENSE` — MIT

## Build & CI

There is no local application build (no Node/pnpm/Make toolchain). The image is
built by `.github/workflows/main.yml`, which calls reusable workflows from
[`owncloud-docker/ubuntu`](https://github.com/owncloud-docker/ubuntu):

- Matrix builds two releases: `10.16.3` (base `v22.04`) and `11.0.0-prealpha`
  (base `v24.04`), each via `<base>/Dockerfile.multiarch`.
- The ownCloud version is injected with the `TARBALL_URL` build arg — there is no
  version pinned inside the Dockerfile.
- Smoke test: `http://localhost:8080/status.php`.
- Trivy vulnerability scan (per-version `.trivyignore`).
- On `master`: push to Docker Hub and sync the README as the image description.

To build locally:

```bash
docker build \
  --build-arg TARBALL_URL=<owncloud-complete-tarball-url> \
  -f v22.04/Dockerfile.multiarch v22.04
```

The image exposes port `8080`, declares volume `/mnt/data`, and inherits its
`ENTRYPOINT` / `occ` dispatcher (`/usr/bin/owncloud`) from `owncloud/base`.

## Development Conventions

- Date-based `CHANGELOG.md` at repo root — **not** a `changelog/unreleased/`
  directory. Prepend a new `## YYYY-MM-DD` section for notable changes.
- Conventional-Commit PR titles, enforced by `lint-pr-title.yml`.
- `.editorconfig` governs formatting.
- GitHub Actions are pinned to full commit SHAs.

## OSPO Policy Constraints

### GitHub Actions
- **Only** use actions owned by `owncloud`, created by GitHub (`actions/*`),
  verified on the GitHub Marketplace, or verified by the ownCloud Maintainers.
- Pin all actions to their full commit SHA (not tags): `uses: actions/checkout@<SHA> # vX.Y.Z`.
- Never introduce actions from unverified third parties.

### Dependency Management
- Dependabot is configured for GitHub Actions updates; Renovate handles Docker
  base-image digest updates.
- Review and merge dependency PRs as part of regular maintenance.

### Git Workflow
- **Rebase policy**: Always rebase; never create merge commits.
- **Signed commits**: All commits **must** be PGP/GPG signed (`git commit -S`).
- **DCO sign-off**: Every commit needs a `Signed-off-by` line (`git commit -s`).
- **Conventional Commits & Squash Merge**: PR titles must follow
  [Conventional Commits](https://www.conventionalcommits.org/); the PR title
  becomes the squash-merge commit message and is enforced by CI.

## Context for AI Agents

- This is a small Docker-image packaging repo, not an application codebase.
- The two `v*/` directories are near-identical; changes usually apply to both.
- The `overlay/` directories are the image root filesystem — add files there to
  ship them in the image; the entrypoint and `occ` subcommand live in the base image.
- The active build system is GitHub Actions (`main.yml`); ignore `.drone.star`.
- The README is published verbatim as the Docker Hub image description — keep it
  accurate and self-contained.
- License is **MIT** (permissive, already compatible with Apache-2.0); no
  copyleft dependency audit is required for relicensing.
