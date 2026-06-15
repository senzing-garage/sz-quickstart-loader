# Makefile extensions for darwin-x86_64.

# -----------------------------------------------------------------------------
# OS-ARCH specific targets
# -----------------------------------------------------------------------------

.PHONY: build-osarch-specific
build-osarch-specific: darwin/amd64


$(eval $(call container_build_target,docker-build-osarch-specific,--platform linux/amd64,$(BUILD_VERSION)))

# -----------------------------------------------------------------------------
# Makefile targets supported only by this platform.
# -----------------------------------------------------------------------------

.PHONY: only-darwin-x86_64
only-darwin-x86_64:
	$(info Only darwin-x86_64 has this Makefile target.)
