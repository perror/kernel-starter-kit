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


obj-m += my_module.o

all:
	@mkdir -p $(ROOTDIR)/initramfs/build
	make -C $(LINUX_HEADERS) M=$(PWD) modules
	make -C $(LINUX_HEADERS) M=$(PWD) INSTALL_MOD_PATH=$(INSTALL_DIR) modules_install

clean:
	make -C $(LINUX_HEADERS) M=$(PWD) clean || true
	@rm -fr *~ *.ko* *.mod.* *.o modules.order Modules.symvers
