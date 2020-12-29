# main file name here
SOURCE_FILE = main

# other sources to compile against (without extensions, separated by spaces). Can be left empty too.
DEPENDENT_FILES = greet

#KERNEL_DIR ?= /lib/modules/`uname -r`/build # system kernel build
KERNEL_DIR ?= ../linux-5.8.14 # local kernel build

obj-m = $(SOURCE_FILE).o # the kernel module name, used by kbuild

# include other source dependencies in the kbuild process
DEPENDENCIES := $(shell echo $(DEPENDENT_FILES) | sed '/^$$/!s/[^ ]*/&\.o/g') # sed '/^$$/!s/\>/\.o/g' was good too (but UNIX dependant)

ifeq ($(DEPENDENCIES),$(subst  ,,$(DEPENDENCIES))) # check is empty or only spaces
$(info no dependencies to compile against)
else
$(info dependencies contains "$(DEPENDENCIES)")
$(SOURCE_FILE)-y := $(SOURCE_FILE).o $(DEPENDENCIES)
endif

all:
	make -C $(KERNEL_DIR) M=`pwd` modules

pack: all
	# pack the compiled module in a gunzip
	echo $(SOURCE_FILE).ko | cpio -H newc -o | gzip > $(SOURCE_FILE).gz
	# add it to the minimal ramdisk for qemu
	cat $(SOURCE_FILE).gz tinyfs.gz > tinyfs_$(SOURCE_FILE).gz

run: pack
	qemu-system-x86_64 -kernel $(KERNEL_DIR)/arch/x86/boot/bzImage -initrd tinyfs_$(SOURCE_FILE).gz

clean:
	make -C $(KERNEL_DIR) M=`pwd` clean
	rm -f $(SOURCE_FILE).gz tinyfs_$(SOURCE_FILE).gz
