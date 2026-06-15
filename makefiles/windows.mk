# Makefile extensions for windows.

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

SENZING_TOOLS_DATABASE_URL ?= sqlite3://na:na@nowhere/C:\Temp\sqlite\G2C.db

# -----------------------------------------------------------------------------
# OS specific targets
# -----------------------------------------------------------------------------

.PHONY: clean-osarch-specific
clean-osarch-specific:
	@del /F /S /Q $(GOPATH)/bin/$(PROGRAM_NAME)
	@del /F /S /Q $(MAKEFILE_DIRECTORY)/coverage.html
	@del /F /S /Q $(MAKEFILE_DIRECTORY)/coverage.out
	@del /F /S /Q $(MAKEFILE_DIRECTORY)/cover.out
	@del /F /S /Q $(TARGET_DIRECTORY)
	@del /F /S /Q C:\Temp\sqlite
	@taskkill /f /t/im godoc
ifneq ($(CONTAINER_RUNTIME),container)
	@$(COMPOSE) -f docker-compose.test.yaml down
endif


.PHONY: coverage-osarch-specific
coverage-osarch-specific:
	@go test -v -coverprofile=coverage.out -p 1 ./...
	@go tool cover -html="coverage.out" -o coverage.html
	@explorer file://$(MAKEFILE_DIRECTORY)/coverage.html


$(eval $(call container_build_target,docker-build-osarch-specific,,$(BUILD_VERSION)))


.PHONY: documentation-osarch-specific
documentation-osarch-specific:
	@taskkill /f /t/im godoc
	@start /b godoc
	@explorer http://localhost:6060


.PHONY: hello-world-osarch-specific
hello-world-osarch-specific:
	$(info Hello World, from windows.)


.PHONY: package-osarch-specific
package-osarch-specific:
	$(info No packaging for windows)


.PHONY: run-osarch-specific
run-osarch-specific:
	@go run main.go


.PHONY: setup-osarch-specific
setup-osarch-specific:
	@mkdir C:\Temp\sqlite
	@copy testdata\sqlite\G2C.db C:\Temp\sqlite\G2C.db
	@mkdir $(TARGET_DIRECTORY)\
	@mkdir $(TARGET_DIRECTORY)\$(GO_OS)-$(GO_ARCH)


.PHONY: test-osarch-specific
test-osarch-specific:
	@go test -json -v -p 1 ./... 2>&1 | tee /tmp/gotest.log | gotestfmt

# -----------------------------------------------------------------------------
# Makefile targets supported only by this platform.
# -----------------------------------------------------------------------------

.PHONY: only-windows
only-windows:
	$(info Only windows has this Makefile target.)
