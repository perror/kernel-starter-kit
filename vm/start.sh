#!/bin/bash

EXIT_CODE=1
DEBUG_OPTS=
INITRAMFS=initramfs.cpio.gz

# Parsing the options (if any)
while [ "$1" != "" ]; do
    case $1 in
        -d | --debug )
	    DEBUG_OPTS='-s -S'
            ;;
	-h | --help )
	    EXIT_CODE=0
	    ;&
        * )
            echo "usage: $(basename $0) [-d|--debug] [-h|--help]"
	    echo ""
	    echo "-d, --debug	Start the kernel for remote debug"
	    echo "-h, --help	Display this help"
	    exit $EXIT_CODE
    esac
    shift
done

# Create the mount point if needed
mkdir -p mnt/

# Running QEMU
qemu-system-aarch64 \
    -machine virt -cpu cortex-a57 \
    -kernel Image.gz \
    -initrd initramfs.cpio.gz \
    -append 'console=ttyAMA0 oops=panic panic=1' \
    -nographic \
    -no-reboot \
    $DEBUG_OPTS
