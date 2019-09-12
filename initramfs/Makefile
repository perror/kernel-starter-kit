.PHONY: all clean allclean distclean

##################################################################
# Global settings
##################################################################

# Main directories
FS_DIR=fs
BUILD_DIR=build
INSTALL_DIR=_install
CONFIG_DIR=../config

# Define functions to check undefined variables
check_defined = $(if $(value $(strip $1)),,\
$(error $1 undefined !))

$(call check_defined, INITRAMFS_CPIO)
$(call check_defined, BUSYBOX_ARCH)
$(call check_defined, BUSYBOX_ARCHIVE)
$(call check_defined, BUSYBOX_VERSION)
$(call check_defined, BUSYBOX_URL)

# Busybox automated settings
BUSYBOX_DIR=busybox-$(BUSYBOX_VERSION)


##################################################################
# Default rule
##################################################################
all: $(INITRAMFS_CPIO)

$(INITRAMFS_CPIO): | $(BUSYBOX_DIR)/$(INSTALL_DIR)
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && \
	  mkdir -p bin sbin etc lib/modules proc sys usr/bin usr/sbin
	cp -a $(FS_DIR)/* $(BUILD_DIR)/
	cp -ar $(BUSYBOX_DIR)/$(INSTALL_DIR)/* $(BUILD_DIR)

#	Build initramfs
	cp -f $(FS_DIR)/init $(BUILD_DIR)
	cd $(BUILD_DIR) && \
	  find . -print0 | \
	  cpio --null -ov --format=newc | \
	  gzip -9 > ../$(INITRAMFS_CPIO)


##################################################################
# Build Busybox
##################################################################
$(BUSYBOX_DIR)/$(INSTALL_DIR): | $(BUSYBOX_DIR)
	cd $(BUSYBOX_DIR) && \
	make ARCH=$(BUSYBOX_ARCH) menuconfig && \
	make ARCH=$(BUSYBOX_ARCH) -j$(BUILD_JOBS) && \
	make ARCH=$(BUSYBOX_ARCH) install

$(BUSYBOX_DIR): $(CONFIG_DIR)/$(BUSYBOX_ARCHIVE)
	mkdir -p $@
	tar --strip 1 -xvf $< -C $@
	cp -f $(CONFIG_DIR)/busybox-config $(BUSYBOX_DIR)/.config

$(CONFIG_DIR)/$(BUSYBOX_ARCHIVE):
	wget https://busybox.net/downloads/$(BUSYBOX_ARCHIVE) -O $@


##################################################################
# Clean rules
##################################################################
clean:
	make -C $(BUSYBOX_DIR) clean || true
	@rm -rf $(INITRAMFS_CPIO) $(BUILD_DIR) *~

allclean: clean

distclean: allclean
	@rm -rf $(BUSYBOX_DIR)
	@rm -f $(CONFIG_DIR)/$(BUSYBOX_ARCHIVE)
