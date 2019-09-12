# Set rootdir
ROOTDIR=$(abspath $(PWD)/../..)
CONFIG_DIR=$(ROOTDIR)/config
INSTALL_DIR=$(ROOTDIR)/initramfs/build

# Import specific settings
-include $(CONFIG_DIR)/Makefile.inc

# Set cross-compilation variables
export ARCH=$(LINUX_ARCH)

# Path to current linux kernel rootdir
LINUX_HEADERS=$(ROOTDIR)/linux-$(LINUX_VERSION)

MODULE_NAME=my_module

obj-m += $(MODULE_NAME).o

all:
	@mkdir -p $(ROOTDIR)/initramfs/build
	make -C $(LINUX_HEADERS) M=$(PWD) modules
	make -C $(LINUX_HEADERS) M=$(PWD) INSTALL_MOD_PATH=$(INSTALL_DIR) modules_install

install: all
	@echo "Installing module in vm/mnt/..."
	@mkdir -p ../../mv/mnt
	@cp -f  $(MODULE_NAME).ko ../../vm/mnt

clean:
	make -C $(LINUX_HEADERS) M=$(PWD) clean || true
	@rm -fr *~ *.ko* *.mod.* *.o modules.order Modules.symvers