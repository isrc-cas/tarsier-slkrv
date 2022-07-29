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

HollaLinux now sets all `LIBDIRSUFFIX` in SlackBuild to "" for riscv64
because the default `LIBDIRSUFFIX` for non-x86_64 architecture is "",
and the build scripts are just executed with no modification
being a testing method at first.

There comes difference to _fede2cr_'s work in the source that `LIBDIRSUFFIX`
is set to "64" in some of his SlackBuild scripts while
in some others is not set and default to "".
This makes it mostly uncompatible with HollaLinux and
HollaLinux is not a drop-in replacement with these previous porting work.

HollaLinux might follow the convention to use `LIBDIRSUFFIX="64"` 
in future, or maybe just keep using `LIBDIRSUFFIX=""`,
depending on whether multilib support for riscv32 is such an importance or not.
