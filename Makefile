# desired module name
MODULE_NAME = example_module

# all source names (both main and its dependencies) without extensions, separated by spaces
SOURCES = main greet

# system kernel build
#KERNEL_DIR ?= /lib/modules/`uname -r`/build

# local kernel build
KERNEL_DIR ?= ../linux-5.8.14

# main object, used by kbuild to produce the final MODULE_NAME.ko file
obj-m = $(MODULE_NAME).o

# source dependencies in the kbuild process
#$(MODULE_NAME)-objs := $(shell echo $(SOURCES) | sed '/^$$/!s/\>/\.o/g')
# or simply...
$(MODULE_NAME)-objs := $(addsuffix .o, $(SOURCES))

all:
	make -C $(KERNEL_DIR) M=`pwd` modules

pack: all
	# pack the compiled module in a gunzip
	echo $(MODULE_NAME).ko | cpio -H newc -o | gzip > tmp_$(MODULE_NAME).gz
	# add it to the minimal ramdisk for qemu
	cat tmp_$(MODULE_NAME).gz tinyfs.gz > tinyfs_$(MODULE_NAME).gz

run: pack
	qemu-system-x86_64 -kernel $(KERNEL_DIR)/arch/x86/boot/bzImage -initrd tinyfs_$(MODULE_NAME).gz

clean:
	make -C $(KERNEL_DIR) M=`pwd` clean
	rm -f tmp_$(MODULE_NAME).gz tinyfs_$(MODULE_NAME).gz
