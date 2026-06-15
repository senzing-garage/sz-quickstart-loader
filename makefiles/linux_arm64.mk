# Makefile extensions for linux-arm64.

# -----------------------------------------------------------------------------
# OS-ARCH specific targets
# -----------------------------------------------------------------------------

.PHONY: build-osarch-specific
build-osarch-specific: linux/arm64
	@mkdir -p $(TARGET_DIRECTORY)/linux
	@cp $(TARGET_DIRECTORY)/linux-arm64/$(PROGRAM_NAME) $(TARGET_DIRECTORY)/linux/$(PROGRAM_NAME)


$(eval $(call container_build_target,docker-build-osarch-specific,--platform linux/arm64,$(BUILD_VERSION)))

# -----------------------------------------------------------------------------
# Makefile targets supported only by this platform.
# -----------------------------------------------------------------------------

.PHONY: only-linux-arm64
only-linux-arm64:
	$(info Only linux-arm64 has this Makefile target.)
