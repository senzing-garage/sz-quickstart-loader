# Makefile extensions for linux.

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

LD_LIBRARY_PATH ?= /opt/senzing/er/lib
SENZING_TOOLS_DATABASE_URL ?= sqlite3://na:na@nowhere/tmp/sqlite/G2C.db
PATH := $(MAKEFILE_DIRECTORY)/bin:/$(HOME)/go/bin:$(PATH)

# -----------------------------------------------------------------------------
# OS specific targets
# -----------------------------------------------------------------------------

.PHONY: clean-osarch-specific
clean-osarch-specific:
	@$(CONTAINER_RM) $(DOCKER_CONTAINER_NAME) 2> /dev/null || true
	@$(CONTAINER_RMI) $(DOCKER_IMAGE_NAME) $(DOCKER_BUILD_IMAGE_NAME) $(DOCKER_SUT_IMAGE_NAME) 2> /dev/null || true
	@rm -f  $(GOPATH)/bin/$(PROGRAM_NAME) || true
	@rm -f  $(MAKEFILE_DIRECTORY)/.coverage || true
	@rm -f  $(MAKEFILE_DIRECTORY)/coverage.html || true
	@rm -f  $(MAKEFILE_DIRECTORY)/coverage.out || true
	@rm -f  $(MAKEFILE_DIRECTORY)/cover.out || true
	@rm -fr $(TARGET_DIRECTORY) || true
	@rm -fr /tmp/sqlite || true
	@pkill godoc || true
ifneq ($(CONTAINER_RUNTIME),container)
	@$(COMPOSE) -f docker-compose.test.yaml down 2> /dev/null || true
endif


.PHONY: coverage-osarch-specific
coverage-osarch-specific: export SENZING_LOG_LEVEL=TRACE
coverage-osarch-specific:
	@go test -v -coverprofile=coverage.out -p 1 ./...
	@go tool cover -html="coverage.out" -o coverage.html
	@xdg-open $(MAKEFILE_DIRECTORY)/coverage.html


.PHONY: dependencies-for-development-osarch-specific
dependencies-for-development-osarch-specific:
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/main/install.sh | sh -s -- -b $(shell go env GOPATH)/bin latest


.PHONY: documentation-osarch-specific
documentation-osarch-specific:
	@pkill godoc || true
	@godoc &
	@xdg-open http://localhost:6060


.PHONY: hello-world-osarch-specific
hello-world-osarch-specific:
	$(info Hello World, from linux.)


.PHONY: package-osarch-specific
package-osarch-specific: docker-build-package
ifeq ($(CONTAINER_RUNTIME),container)
	@echo "ERROR: package-osarch-specific uses 'container cp', which Apple 'container' does not provide." >&2
	@echo "Re-run with CONTAINER_RUNTIME=docker or CONTAINER_RUNTIME=podman." >&2
	@exit 1
else
	@mkdir -p $(TARGET_DIRECTORY) || true
	@CONTAINER_ID=$$($(CONTAINER_RUNTIME) create $(DOCKER_BUILD_IMAGE_NAME)); \
	$(CONTAINER_RUNTIME) cp $$CONTAINER_ID:/output/. $(TARGET_DIRECTORY)/; \
	$(CONTAINER_RM) $$CONTAINER_ID
endif


.PHONY: run-osarch-specific
run-osarch-specific:
	@go run main.go


.PHONY: setup-osarch-specific
setup-osarch-specific:
	@mkdir /tmp/sqlite
	@cp testdata/sqlite/G2C.db /tmp/sqlite/G2C.db
	@mkdir -p $(TARGET_DIRECTORY)/$(GO_OS)-$(GO_ARCH) || true


.PHONY: test-osarch-specific
test-osarch-specific:
	@go test -json -v -p 1 ./... 2>&1 | tee /tmp/gotest.log | gotestfmt

# -----------------------------------------------------------------------------
# Makefile targets supported only by this platform.
# -----------------------------------------------------------------------------

.PHONY: only-linux
only-linux:
	$(info Only linux has this Makefile target.)
