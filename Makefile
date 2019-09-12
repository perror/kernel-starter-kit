.PHONY: all allclean clean distclean download help gdbinit \
	install kernel-build initramfs-clean kernel-clean

##################################################################
# Global settings
##################################################################

# Main directories
VM_DIR=vm
MODULES_DIR=modules
INITRAMFS_DIR=initramfs
CONFIG_DIR=config

# Exported variables (needed in initramfs/)
export INITRAMFS_CPIO=initramfs.cpio.gz

# Import specific settings
-include $(CONFIG_DIR)/Makefile.inc

# Define functions to check undefined variables
check_defined = $(if $(value $(strip $1)),,\
$(error $1 undefined !))

$(call check_defined, LINUX_VERSION)
$(call check_defined, LINUX_IMG)
$(call check_defined, BUILD_JOBS)
$(call check_defined, BUSYBOX_VERSION)

# Automated settings
LINUX_DIR=linux-$(LINUX_VERSION)
LINUX_ARCHIVE=linux-$(LINUX_VERSION).tar.xz
LINUX_URL=https://cdn.kernel.org/pub/linux/kernel/v$(basename $(basename $(LINUX_VERSION))).x
LINUX_SYSTEM_MAP=System.map

export BUSYBOX_ARCHIVE=busybox-$(BUSYBOX_VERSION).tar.bz2
export BUSYBOX_URL=https://busybox.net/downloads/$(BUSYBOX_ARCHIVE)


##################################################################
# Default rule
##################################################################
all:
	make kernel-build
	make -C $(MODULES_DIR)
	make -C $(INITRAMFS_DIR)
	make install

	@echo ""
	@echo "#################################"
	@echo "     Your VM is built in $(VM_DIR)/"
	@echo "#################################"


##################################################################
# Download archives
##################################################################
download: $(CONFIG_DIR)/$(LINUX_ARCHIVE) $(CONFIG_DIR)/$(BUSYBOX_ARCHIVE)

$(CONFIG_DIR)/$(BUSYBOX_ARCHIVE):
	wget https://busybox.net/downloads/$(BUSYBOX_ARCHIVE) -O $@


##################################################################
# Build Linux kernel
##################################################################
kernel-build: $(LINUX_DIR)/arch/$(LINUX_ARCH)/boot/$(LINUX_IMG) \
	      $(LINUX_DIR)/$(LINUX_SYSTEM_MAP)

$(LINUX_DIR)/arch/$(LINUX_ARCH)/boot/$(LINUX_IMG) \
$(LINUX_DIR)/$(LINUX_SYSTEM_MAP): | $(LINUX_DIR)
	@mkdir -p $(INITRAMFS_DIR)/build
	cd $(LINUX_DIR) && \
	make ARCH=$(LINUX_ARCH) menuconfig && \
	make ARCH=$(LINUX_ARCH) -j$(BUILD_JOBS) && \
	make ARCH=$(LINUX_ARCH) INSTALL_MOD_PATH=$(INITRAMFS_DIR)/build modules_install

$(LINUX_DIR): $(CONFIG_DIR)/$(LINUX_ARCHIVE) $(CONFIG_DIR)/linux-config
	mkdir -p $(LINUX_DIR)
	tar --strip 1 -xvf $< -C $(LINUX_DIR)
	cp -f $(CONFIG_DIR)/linux-config $(LINUX_DIR)/.config

$(CONFIG_DIR)/$(LINUX_ARCHIVE):
	wget $(LINUX_URL)/$(LINUX_ARCHIVE) -O $@


##################################################################
# Build ~/.gdbinit rule
##################################################################
gdbinit:
	@if [ -w ~/.gdbinit ]; then \
	  NONCE=$(shell cat /dev/urandom | tr -dc '0-9' | fold -w 8 | head -n 1); \
	  mv ~/.gdbinit ~/.gdbinit.$$NONCE; \
	fi
	@echo "add-auto-load-safe-path $(PWD)/$(LINUX_DIR)" > ~/.gdbinit


##################################################################
# Install rules
##################################################################
install: $(VM_DIR)/$(LINUX_IMG) \
	 $(VM_DIR)/$(LINUX_SYSTEM_MAP) \
	 $(VM_DIR)/$(INITRAMFS_CPIO)

$(VM_DIR)/$(LINUX_IMG) $(VM_DIR)/$(LINUX_SYSTEM_MAP) $(VM_DIR)/$(INITRAMFS_CPIO): \
	$(LINUX_DIR)/arch/$(LINUX_ARCH)/boot/$(LINUX_IMG) \
	$(LINUX_DIR)/$(LINUX_SYSTEM_MAP) \
	$(INITRAMFS_DIR)/$(INITRAMFS_CPIO)
	cp -f $^ $(VM_DIR)


##################################################################
# Clean rules
##################################################################
clean:
	make -C $(MODULES_DIR) clean
	make -C $(INITRAMFS_DIR) clean
	@rm -f $(LINUX_DIR)/arch/$(LINUX_ARCH)/boot/$(LINUX_IMG)
	@rm -f $(VM_DIR)/$(LINUX_IMG) \
	       $(VM_DIR)/$(LINUX_SYSTEM_MAP) \
	       $(VM_DIR)/$(INITRAMFS_CPIO)
	@rm -f *~

kernel-clean:
	make -C $(LINUX_DIR) clean

initramfs-clean:
	make -C $(INITRAMFS_DIR) allclean

allclean: clean kernel-clean initramfs-clean
	@rm -f $(VM_DIR)/$(LINUX_IMG) $(VM_DIR)/$(LINUX_SYSTEM_MAP)
	@rm -f $(VM_DIR)/$(INITRAMFS_CPIO)

distclean: clean
	make -C $(MODULES_DIR) distclean
	make -C $(INITRAMFS_DIR) distclean

	@rm -rf $(LINUX_DIR)
	@rm -f $(CONFIG_DIR)/$(LINUX_ARCHIVE)

	@rm -f $(VM_DIR)/$(INITRAMFS_CPIO)
	@rm -f $(VM_DIR)/$(LINUX_IMG)
	@rm -f $(VM_DIR)/$(LINUX_SYSTEM_MAP)
	@rm -rf $(VM_DIR)/mnt


##################################################################
# Help rule
##################################################################
help:
	@echo "Makefile usage:"
	@echo
	@echo "make <all>            Build the full environment"
	@echo "make download         Download the needed archives"
	@echo "make gdbinit          Build a ~/.gdbinit for the kernel"
	@echo "make install          Install the full environment"
	@echo "make clean            Clean modules sources"
	@echo "make initramfs-clean  Clean file-system image"
	@echo "make kernel-clean     Clean kernel sources"
	@echo "make allclean         Remove all object files"
	@echo "make distclean        Remove all generated files"
	@echo "make help             Display this help"
