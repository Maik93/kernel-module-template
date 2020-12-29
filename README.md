# Kernel modules with Clion IDE support
This setup allows Clion IDE to support you with syntax highlights and other convenient IDE stuff while developing kernel modules.

Clion doesn't build the kernel module itself, it just supports you while coding.
You have to execute `make` on the command line by yourself to build your `.ko`-file!

## How to
Copy base files on your project directory:
```shell
PROJ_DIR=new_module
mkdir ../$PROJ_DIR
cp -r main.c Makefile CMakeLists.txt cmake tinyfs.gz ../$PROJ_DIR
# main.c is only a template
```

Just edit the first two line of `Makefile`, then:
- `make` or `make all`: compile the module;
- `make pack`: add the module to `tinyfs_base.gz`, a basic initram image to test with;
- `make run`: build the module, pack it and run qemu to test it.

On qemu:
- the built module is under `/`;
- sadly some command is not in the source path, so to call, e.g. `lsmod`, you have to type `/sbin/lsmod`;

Quick run a module:
```shell
sudo /sbin/insmod /module_name.ko # ignore the out-of-tree warning
/sbin/lsmod # will list the loaded module
```

If your mouse is taken from the window, just press `ctrl+alt+G`.

## Notes
- latest kernel headers must be installed `pacman -S linux-headers`;
- if using something different from the almighty Archlinux, maybe you have to change `cmake/FindKernelHeaders.cmake:14` according to your kernel headers directory;
- the `tinyfs.gz` file is produced using this: https://gitlab.retis.sssup.it/l.abeni/BuildCore.git
- inside qemu, you can load an Italian keyboard with `sudo /sbin/loadkmap < /etc/keymaps/italian.kmap`.

## Based on
- https://gitlab.com/phip1611/cmake-kernel-module
- https://gitlab.com/christophacham/cmake-kernel-module