# jfheinrich/pre-commit

## Table of Contents

- [jfheinrich/pre-commit](#jfheinrichpre-commit)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Build the image](#build-the-image)
  - [Usage](#usage)
    - [Usage in a Gitlab CI/CD merge request pipeline](#usage-in-a-gitlab-cicd-merge-request-pipeline)
  - [The internal .pre-commit-config.yaml](#the-internal-pre-commit-configyaml)

## About

Image which wrap the pre-commit suite could be used in CD/CD pipelines and on command line

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need following tools installed:

- GNU make
- orbstack
- docker with buildx and scout

on Mac:

```
brew install make orbstack docker-buildx
```

### Build the image

Create a local image with `make build`

Runs `docker build` and `docker scout cves`

```bash
$ make docker-login -e DOCKERUSER=<Username> build
```

Build the multiarch image and push it to docker hub:

```bash
make docker-login -e DOCKERUSER=<Username> build-and-push
```

Logout form docker hub:

```bash
make docker logout
```

## Usage

There are two blocks of parameters, one for the image self and second for the pre-commit command

to get the image options:

```bash
$ docker run --rm -v $(pwd):/builds jfheinrich/pre-commit:1.1.0  --image-help
  Docker image options:

  -i | --image-help         Shiw this help page
  -s | --shell              Open a shell into the container
  -n | --no-build-in-config Do not use the internal .pre-commit-config.yaml
  -e | --env                Set environment variables for pre-commit
  -u | --update-hook        Updates the hook versions in the config file,
                            should used with --no-build-in-config
  -c | --copy-config-example copy the internal pre-commit config as .pre-commit-config-example.yaml
                             into the volume path

```

and you got the options for pre-commit with

```bash
docker run --rm -v $(pwd):/builds jfheinrich/pre-commit:latest --no-build-in-config --help
```

or get help for a specific pre-commit command:

```bash
docker run --rm -v $(pwd):/builds jfheinrich/pre-commit:latest --no-build-in-config -- help [pre-commit command]
```

Example run of the pre-commit image:

```bash
docker run --rm -v $(pwd):/builds jfheinrich/pre-commit:latest \
    --no-build-in-config \
    --env SKIP="check-executables-have-shebangs" -- \
    run --color always --config .pre-commit-ci.yaml --all-files
```

This runs the pre-commit command with
- skip the `check-executables-have-shebangs` hook
- use the local config file `.pre-commit-ci.yaml` instead of the build in config
- enable colored output
- run overall files

### Usage in a Gitlab CI/CD merge request pipeline

```yaml
pre-commit:
  stage: test
  image:
    name: jfheinrich/pre-commit:latest
    entrypoint: [""]
  environment:
    SKIP="check-executables-have-shebangs"
  script:
    - pre-commit run --color always --config .pre-commit-ci.yaml --files $(git diff-tree --name-only --no-commit-id $CI_MERGE_REQUEST_TARGET_BRANCH_SHA)
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

## The internal .pre-commit-config.yaml

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: no-commit-to-branch
      - id: check-merge-conflict
        args: [--assume-in-merge]
      - id: check-executables-have-shebangs
      - id: check-shebang-scripts-are-executable
      - id: destroyed-symlinks
      - id: end-of-file-fixer
      - id: fix-byte-order-marker
      - id: mixed-line-ending
      - id: trailing-whitespace
  - repo: https://github.com/thoughtworks/talisman
    rev: "v1.33.0"
    hooks:
      # both pre-commit and pre-push supported
      # -   id: talisman-push
      - id: talisman-commit

```
