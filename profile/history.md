# HollaLinux History

HollaLinux was at first to build riscv64 port of Slackware from scratch
as a mean to assess cross build capability of other distros.

There was a nice [Slackware riscv64 port](https://github.com/fede2cr/slackware_riscv)
already done by [Alvaro Figueroa (fede2cr)](https://github.com/fede2cr),
but it did not provide a bootable media and unfortunately 
did not run smoothly during test within our chroot environment.

Later HollaLinux became a new project to build another
riscv64 port of Slackware since we successfully achieved booting
on QEMU. 
Build of Hollalinux is starting from Slackware 15.0 release source tree,
combining some upgrades from the current branch,
and making modifications or adding patches to make it build on riscv64.

The main difference to _fede2cr_'s work in source is that 
__LIBDIRSUFFIX__ in SlackBuild scripts is set to "" raher than "64",
because the default __LIBDIRSUFFIX__ for non-x86_64 architecture is "",
and at first as a testing method,
the build scripts are just executed being unchanged. 
With the AArch64 port of Slackware using LIBDIRSUFFIX="64",
HollaLinux will also follow this convention in future releases.
