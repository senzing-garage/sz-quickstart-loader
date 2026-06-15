# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`senzing/sz-quickstart-loader` is a container that wraps Senzing's `sz_file_loader` CLI for quickstart usage. Built on `senzing/senzingsdk-runtime` with `senzingsdk-poc` installed for loader capabilities.

## Build Commands

```bash
# Build container image (auto-detects runtime: container > podman > docker on macOS, docker on Linux/Windows)
make docker-build

# Force a specific runtime
CONTAINER_RUNTIME=podman make docker-build

# Clean up images
make clean
```

## Repository Structure

- `Dockerfile` - Image definition; pulls senzingsdk-poc on top of senzingsdk-runtime
- `Makefile` + `makefiles/` - Build automation, OS detection
- `docs/` - Documentation

## Conventions

### Dockerfile updates

When modifying the Dockerfile, update the `REFRESHED_AT` ENV date to the current date. (The base image is pinned by digest and the Dockerfile sets `REFRESHED_AT`; `docker-verify-refreshed-at-updated.yaml` enforces that it changes whenever the Dockerfile does.)

### Version

Version is tracked in the `Dockerfile` `LABEL Version` field.

## CI/CD

Standard Senzing-garage Docker workflows:

- `docker-build-container.yaml` - Builds + tests on PR
- `docker-push-containers-to-dockerhub.yaml` - Publishes to Docker Hub on tag / scheduled
- `docker-verify-refreshed-at-updated.yaml` - Enforces REFRESHED_AT update when the Dockerfile changes
- `spellcheck.yaml`, `lint-workflows.yaml` - Standard checks
