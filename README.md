# Kernel modules with Clion IDE support
This setup allows Clion IDE to support you with syntax highlights and other convenient IDE stuff while developing kernel modules.

Clion doesn't build the kernel module itself, it just supports you while coding.
You have to execute `make` on the command line by yourself to build your `.ko`-file!

## How to
Just edit the first two line of `Makefile`, then:
- `make` or `make all`: compile the module;
- `make pack`: add the module to `tinyfs_base.gz`, a basic initram image to test with;
- `make run`: build the module, pack it and run qemu to test it.

## Notes
- latest kernel headers must be installed `pacman -S linux-headers`;
- if using something different from the almighty Archlinux, maybe you have to change `cmake/FindKernelHeaders.cmake:14` according to your kernel headers directory;
- the `tinyfs.gz` file is produced using this: https://gitlab.retis.sssup.it/l.abeni/BuildCore.git
- inside qemu, you can load an Italian keyboard with `sudo /sbin/loadkmap < /etc/keymaps/italian.kmap`.

## Based on
- https://gitlab.com/phip1611/cmake-kernel-module
- https://gitlab.com/christophacham/cmake-kernel-module