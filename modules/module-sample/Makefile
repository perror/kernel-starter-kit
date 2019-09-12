# Set rootdir
ROOTDIR=$(abspath $(PWD)/../..)
INSTALL_DIR=$(abspath $(ROOTDIR)/initramfs/build)

# Import specific settings
-include $(ROOTDIR)/config/Makefile.inc

# Set cross-compilation variables
export ARCH=$(LINUX_ARCH)

# Path to current linux kernel rootdir
LINUX_HEADERS=$(ROOTDIR)/linux-$(LINUX_VERSION)

MODULE_NAME=my_module

obj-m += $(MODULE_NAME).o

all:
	@mkdir -p $(INSTALL_DIR)
	@touch $(INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/modules.builtin
	@touch $(INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/modules.order
	make -C $(LINUX_HEADERS) M=$(PWD) modules
	make -C $(LINUX_HEADERS) M=$(PWD) INSTALL_MOD_PATH=$(INSTALL_DIR) modules_install

install: all
	@echo "Installing module in vm/mnt/..."
	@mkdir -p $(ROOTDIR)/vm/mnt
	@cp -f  $(MODULE_NAME).ko $(ROOTDIR)/vm/mnt

clean:
	make -C $(LINUX_HEADERS) M=$(PWD) clean || true
	@rm -fr *~ *.ko* *.mod.* *.o modules.order Modules.symvers
	@rm -f $(INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/modules.builtin
	@rm -f $(INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/modules.order
