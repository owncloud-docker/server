DOCKER_PUSHRM_IMAGE = "docker.io/chko/docker-pushrm:1"
DRONE_DOCKER_BUILDX_IMAGE = "docker.io/owncloudci/drone-docker-buildx:3"
MARIADB_IMAGE = "docker.io/mariadb:11.2"
REDIS_IMAGE = "docker.io/redis:6"
UBUNTU_IMAGE = "docker.io/owncloud/ubuntu:20.04"
STANDALONE_CHROME_DEBUG_IMAGE = "docker.io/selenium/standalone-chrome-debug:3.141.59-oxygen"

def main(ctx):
    versions = [
        {
            "value": "10.13.4",
            "tarball": "https://download.owncloud.com/server/stable/owncloud-complete-20231213.tar.bz2",
            "tarball_sha": "4e39c500cd99e2b2a988d593aa43bf67c29e6704ecbe03fc068872f37018f523",
            "php": "7.4",
            "base": "v20.04",
            "tags": ["10.13", "10", "latest"],
        },
        {
            "value": "10.12.2",
            "tarball": "https://download.owncloud.com/server/stable/owncloud-complete-20230606.tar.bz2",
            "tarball_sha": "3775bbaae65eb80013d0558126df927f0e6c5d58eb0968b88222bcd2a5de8de8",
            "php": "7.4",
            "base": "v20.04",
            "tags": ["10.12"],
        },
    ]

    config = {
        "version": None,
        "splitAPI": 10,
        "splitUI": 5,
        "description": "ownCloud - Secure Collaboration Platform",
        "repo": ctx.repo.name,
    }

    stages = []
    shell = []
    shell_bases = []
    linter = lint(config)

    for version in versions:
        config["version"] = version

        if config["version"]["base"] not in shell_bases:
            shell_bases.append(config["version"]["base"])
            shell.extend(shellcheck(config))

        config["version"]["qa"] = config["version"].get("qa", "https://download.owncloud.com/server/daily/owncloud-daily-master-qa.tar.bz2")
        config["version"]["behat"] = config["version"].get("behat", "https://raw.githubusercontent.com/owncloud/core/master/vendor-bin/behat/composer.json")

        inner = []

        config["internal"] = "%s-%s-%s" % (ctx.build.commit, "${DRONE_BUILD_NUMBER}", config["version"]["value"])
        config["version"]["tags"] = version.get("tags", [])
        config["version"]["tags"].append(config["version"]["value"])

        for d in docker(config):
            d["depends_on"].append(linter["name"])
            inner.append(d)

        stages.extend(inner)

    linter["steps"].extend(shell)

    after = [
        documentation(config),
        rocketchat(config),
    ]

    for s in stages:
        for a in after:
            a["depends_on"].append(s["name"])

    return [linter] + stages + after

def docker(config):
    pre = [{
        "kind": "pipeline",
        "type": "docker",
        "name": "prepublish-%s" % (config["version"]["value"]),
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "steps": download(config) + prepublish(config) + sleep(config) + trivy(config),
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/pull/**",
            ],
        },
    }]

    post = [{
        "kind": "pipeline",
        "type": "docker",
        "name": "cleanup-%s" % (config["version"]["value"]),
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "clone": {
            "disable": True,
        },
        "steps": cleanup(config),
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/pull/**",
            ],
            "status": [
                "success",
                "failure",
            ],
        },
    }]

    push = [{
        "kind": "pipeline",
        "type": "docker",
        "name": "publish-%s" % (config["version"]["value"]),
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "steps": download(config) + publish(config),
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
            ],
        },
    }]

    test = []

    for step in list(range(1, config["splitAPI"] + 1)):
        config["step"] = step

        test.append({
            "kind": "pipeline",
            "type": "docker",
            "name": "api%d-%s" % (config["step"], config["version"]["value"]),
            "platform": {
                "os": "linux",
                "arch": "amd64",
            },
            "clone": {
                "disable": True,
            },
            "steps": wait_server(config) + api(config),
            "services": [
                {
                    "name": "server",
                    "image": "registry.drone.owncloud.com/owncloud/%s:%s" % (config["repo"], config["internal"]),
                    "environment": {
                        "DEBUG": "true",
                        "OWNCLOUD_TRUSTED_DOMAINS": "server",
                        "OWNCLOUD_APPS_INSTALL": "https://github.com/owncloud/testing/releases/download/latest/testing.tar.gz",
                        "OWNCLOUD_APPS_ENABLE": "testing",
                        "OWNCLOUD_REDIS_HOST": "redis",
                        "OWNCLOUD_DB_TYPE": "mysql",
                        "OWNCLOUD_DB_HOST": "mysql",
                        "OWNCLOUD_DB_USERNAME": "owncloud",
                        "OWNCLOUD_DB_PASSWORD": "owncloud",
                        "OWNCLOUD_DB_NAME": "owncloud",
                    },
                },
                {
                    "name": "mysql",
                    "image": MARIADB_IMAGE,
                    "environment": {
                        "MYSQL_ROOT_PASSWORD": "owncloud",
                        "MYSQL_USER": "owncloud",
                        "MYSQL_PASSWORD": "owncloud",
                        "MYSQL_DATABASE": "owncloud",
                    },
                },
                {
                    "name": "redis",
                    "image": REDIS_IMAGE,
                },
            ],
            "depends_on": [],
            "trigger": {
                "ref": [
                    "refs/heads/master",
                    "refs/pull/**",
                ],
            },
        })

    for step in list(range(1, config["splitUI"] + 1)):
        config["step"] = step

        test.append({
            "kind": "pipeline",
            "type": "docker",
            "name": "ui%d-%s" % (config["step"], config["version"]["value"]),
            "platform": {
                "os": "linux",
                "arch": "amd64",
            },
            "clone": {
                "disable": True,
            },
            "steps": wait_server(config) + wait_email(config) + ui(config),
            "services": [
                {
                    "name": "server",
                    "image": "registry.drone.owncloud.com/owncloud/%s:%s" % (config["repo"], config["internal"]),
                    "environment": {
                        "DEBUG": "true",
                        "OWNCLOUD_TRUSTED_DOMAINS": "server",
                        "OWNCLOUD_APPS_INSTALL": "https://github.com/owncloud/testing/releases/download/latest/testing.tar.gz",
                        "OWNCLOUD_APPS_ENABLE": "testing",
                        "OWNCLOUD_REDIS_HOST": "redis",
                        "OWNCLOUD_DB_TYPE": "mysql",
                        "OWNCLOUD_DB_HOST": "mysql",
                        "OWNCLOUD_DB_USERNAME": "owncloud",
                        "OWNCLOUD_DB_PASSWORD": "owncloud",
                        "OWNCLOUD_DB_NAME": "owncloud",
                    },
                },
                {
                    "name": "mysql",
                    "image": MARIADB_IMAGE,
                    "environment": {
                        "MYSQL_ROOT_PASSWORD": "owncloud",
                        "MYSQL_USER": "owncloud",
                        "MYSQL_PASSWORD": "owncloud",
                        "MYSQL_DATABASE": "owncloud",
                    },
                },
                {
                    "name": "redis",
                    "image": REDIS_IMAGE,
                },
                {
                    "name": "email",
                    "image": "docker.io/inbucket/inbucket",
                },
                {
                    "name": "selenium",
                    "image": STANDALONE_CHROME_DEBUG_IMAGE,
                },
            ],
            "depends_on": [],
            "trigger": {
                "ref": [
                    "refs/heads/master",
                    "refs/pull/**",
                ],
            },
        })

    for t in test:
        for p in push:
            p["depends_on"].append(t["name"])

        for p in pre:
            t["depends_on"].append(p["name"])

        for p in post:
            p["depends_on"].append(t["name"])

            for x in push:
                p["depends_on"].append(x["name"])

    return pre + test + push + post

def documentation(config):
    return {
        "kind": "pipeline",
        "type": "docker",
        "name": "documentation",
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "steps": [
            {
                "name": "link-check",
                "image": "ghcr.io/tcort/markdown-link-check:stable",
                "commands": [
                    "/src/markdown-link-check README.md",
                ],
            },
            {
                "name": "publish",
                "image": DOCKER_PUSHRM_IMAGE,
                "environment": {
                    "DOCKER_PASS": {
                        "from_secret": "public_password",
                    },
                    "DOCKER_USER": {
                        "from_secret": "public_username",
                    },
                    "PUSHRM_FILE": "README.md",
                    "PUSHRM_TARGET": "owncloud/${DRONE_REPO_NAME}",
                    "PUSHRM_SHORT": config["description"],
                },
                "when": {
                    "ref": [
                        "refs/heads/master",
                    ],
                },
            },
        ],
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/tags/**",
                "refs/pull/**",
            ],
        },
    }

def rocketchat(config):
    return {
        "kind": "pipeline",
        "type": "docker",
        "name": "rocketchat",
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "clone": {
            "disable": True,
        },
        "steps": [
            {
                "name": "notify",
                "image": "docker.io/plugins/slack",
                "failure": "ignore",
                "settings": {
                    "webhook": {
                        "from_secret": "rocketchat_talk_webhook",
                    },
                    "channel": {
                        "from_secret": "rocketchat_talk_channel",
                    },
                },
            },
        ],
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/tags/**",
            ],
            "status": [
                "changed",
                "failure",
            ],
        },
    }

def download(config):
    return [
        {
            "name": "download",
            "image": "docker.io/plugins/download",
            "settings": {
                "source": config["version"]["tarball"],
                "sha256": config["version"]["tarball_sha"],
                "destination": "%s/owncloud.tar.bz2" % config["version"]["base"],
            },
        },
    ]

def prepublish(config):
    return [
        {
            "name": "prepublish",
            "image": DRONE_DOCKER_BUILDX_IMAGE,
            "settings": {
                "username": {
                    "from_secret": "internal_username",
                },
                "password": {
                    "from_secret": "internal_password",
                },
                "tags": config["internal"],
                "dockerfile": "%s/Dockerfile.multiarch" % (config["version"]["base"]),
                "repo": "registry.drone.owncloud.com/owncloud/%s" % config["repo"],
                "registry": "registry.drone.owncloud.com",
                "context": config["version"]["base"],
            },
            "environment": {
                "BUILDKIT_NO_CLIENT_TOKEN": True,
            },
        },
    ]

def sleep(config):
    return [
        {
            "name": "sleep",
            "image": "docker.io/owncloudci/alpine",
            "environment": {
                "DOCKER_USER": {
                    "from_secret": "internal_username",
                },
                "DOCKER_PASSWORD": {
                    "from_secret": "internal_password",
                },
            },
            "commands": [
                "regctl registry login registry.drone.owncloud.com --user $DOCKER_USER --pass $DOCKER_PASSWORD",
                "retry -- 'regctl image digest registry.drone.owncloud.com/owncloud/%s:%s'" % (config["repo"], config["internal"]),
            ],
        },
    ]

# container vulnerability scanning, see: https://github.com/aquasecurity/trivy
def trivy(config):
    return [
        {
            "name": "trivy-presets",
            "image": "docker.io/owncloudci/alpine",
            "commands": [
                'retry -t 3 -s 5 -- "curl -sSfL https://github.com/owncloud-docker/trivy-presets/archive/refs/heads/main.tar.gz | tar xz --strip-components=2 trivy-presets-main/base/"',
            ],
        },
        {
            "name": "trivy-scan",
            "image": "ghcr.io/aquasecurity/trivy",
            "environment": {
                "TRIVY_AUTH_URL": "https://registry.drone.owncloud.com",
                "TRIVY_USERNAME": {
                    "from_secret": "internal_username",
                },
                "TRIVY_PASSWORD": {
                    "from_secret": "internal_password",
                },
                "TRIVY_NO_PROGRESS": True,
                "TRIVY_IGNORE_UNFIXED": True,
                "TRIVY_TIMEOUT": "5m",
                "TRIVY_EXIT_CODE": "1",
                "TRIVY_SEVERITY": "HIGH,CRITICAL",
                "TRIVY_SKIP_FILES": "/usr/bin/gomplate",
            },
            "commands": [
                "trivy -v",
                "trivy image registry.drone.owncloud.com/owncloud/%s:%s" % (config["repo"], config["internal"]),
            ],
        },
    ]

def wait_server(config):
    return [
        {
            "name": "wait-server",
            "image": UBUNTU_IMAGE,
            "commands": [
                "wait-for-it -t 600 server:8080",
            ],
        },
    ]

def wait_email(config):
    return [
        {
            "name": "wait-email",
            "image": UBUNTU_IMAGE,
            "commands": [
                "wait-for-it -t 600 email:9000",
            ],
        },
    ]

def api(config):
    return [
        {
            "name": "api-tarball",
            "image": "docker.io/plugins/download",
            "settings": {
                "source": config["version"]["qa"],
                "destination": "owncloud-qa.tar.bz2",
            },
        },
        {
            "name": "extract",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "commands": [
                "tar -xjf owncloud-qa.tar.bz2 -C /drone/src --strip 1",
            ],
        },
        {
            "name": "version",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "commands": [
                "cat version.php",
            ],
        },
        {
            "name": "behat",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "commands": [
                "mkdir -p vendor-bin/behat",
                "wget -O vendor-bin/behat/composer.json %s" % config["version"]["behat"],
                "cd vendor-bin/behat/ && composer install",
            ],
        },
        {
            "name": "tests",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "environment": {
                "TEST_SERVER_URL": "http://server:8080",
                "SKELETON_DIR": "/mnt/data/apps/testing/data/apiSkeleton",
            },
            "commands": [
                'bash tests/acceptance/run.sh --remote --tags "@smokeTest&&~@skip&&~@skipOnDockerContainerTesting%s" --type api --part %d %d' % (extraTestFilterTags(config), config["step"], config["splitAPI"]),
            ],
        },
    ]

def ui(config):
    return [
        {
            "name": "ui-tarball",
            "image": "docker.io/plugins/download",
            "settings": {
                "source": config["version"]["qa"],
                "destination": "owncloud-qa.tar.bz2",
            },
        },
        {
            "name": "extract",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "commands": [
                "tar -xjf owncloud-qa.tar.bz2 -C /drone/src --strip 1",
            ],
        },
        {
            "name": "version",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "commands": [
                "cat version.php",
            ],
        },
        {
            "name": "behat",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "commands": [
                "mkdir -p vendor-bin/behat",
                "wget -O vendor-bin/behat/composer.json %s" % config["version"]["behat"],
                "cd vendor-bin/behat/ && composer install",
            ],
        },
        {
            "name": "tests",
            "image": "docker.io/owncloudci/php:%s" % config["version"]["php"],
            "environment": {
                "TEST_SERVER_URL": "http://server:8080",
                "SKELETON_DIR": "/mnt/data/apps/testing/data/webUISkeleton",
                "BROWSER": "chrome",
                "SELENIUM_HOST": "selenium",
                "SELENIUM_PORT": "4444",
                "PLATFORM": "Linux",
                "EMAIL_HOST": "email",
                "LOCAL_EMAIL_HOST": "email",
            },
            "commands": [
                'bash tests/acceptance/run.sh --remote --tags "@smokeTest&&~@skip&&~@skipOnDockerContainerTesting%s" --type webUI --part %d %d' % (extraTestFilterTags(config), config["step"], config["splitUI"]),
            ],
        },
    ]

def tests(config):
    return [
        {
            "name": "test",
            "image": UBUNTU_IMAGE,
            "commands": [
                "curl -sSf http://server:8080/status.php",
            ],
        },
    ]

def publish(config):
    return [
        {
            "name": "publish",
            "image": DRONE_DOCKER_BUILDX_IMAGE,
            "settings": {
                "username": {
                    "from_secret": "public_username",
                },
                "password": {
                    "from_secret": "public_password",
                },
                "platforms": [
                    "linux/amd64",
                    "linux/arm64",
                ],
                "tags": config["version"]["tags"],
                "dockerfile": "%s/Dockerfile.multiarch" % (config["version"]["base"]),
                "repo": "owncloud/%s" % config["repo"],
                "context": config["version"]["base"],
                "cache_from": "registry.drone.owncloud.com/owncloud/%s:%s" % (config["repo"], config["internal"]),
                "pull_image": False,
            },
            "when": {
                "ref": [
                    "refs/heads/master",
                ],
            },
        },
    ]

def cleanup(config):
    return [
        {
            "name": "cleanup",
            "image": "docker.io/owncloudci/alpine",
            "failure": "ignore",
            "environment": {
                "DOCKER_USER": {
                    "from_secret": "internal_username",
                },
                "DOCKER_PASSWORD": {
                    "from_secret": "internal_password",
                },
            },
            "commands": [
                "regctl registry login registry.drone.owncloud.com --user $DOCKER_USER --pass $DOCKER_PASSWORD",
                "regctl tag rm registry.drone.owncloud.com/owncloud/%s:%s" % (config["repo"], config["internal"]),
            ],
        },
    ]

def lint(config):
    return {
        "kind": "pipeline",
        "type": "docker",
        "name": "lint",
        "steps": [
            {
                "name": "starlark-format",
                "image": "docker.io/owncloudci/bazel-buildifier",
                "commands": [
                    "buildifier -d -diff_command='diff -u' .drone.star",
                ],
            },
            {
                "name": "editorconfig-format",
                "image": "docker.io/mstruebing/editorconfig-checker",
            },
        ],
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/pull/**",
            ],
        },
    }

def shellcheck(config):
    return [
        {
            "name": "shellcheck-%s" % (config["version"]["base"]),
            "image": "docker.io/koalaman/shellcheck-alpine:stable",
            "commands": [
                "grep -ErlI '^#!(.*/|.*env +)(sh|bash|ksh)' %s/overlay/ | xargs -r shellcheck" % (config["version"]["base"]),
            ],
        },
    ]

def extraTestFilterTags(config):
    if "version" not in config:
        return ""

    if "extraTestFilterTags" not in config["version"]:
        return ""

    if (config["version"]["extraTestFilterTags"] == ""):
        return ""
    else:
        return "&&%s" % config["version"]["extraTestFilterTags"]
