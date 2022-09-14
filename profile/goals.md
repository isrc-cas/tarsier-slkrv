# HollaLinux Goals
As part of the Tarsier Projects to help building 
the software ecosystem upon RISC-V desktop devices,
this unofficial riscv64 porting project of Slackware
does not aim to support any other architecture than riscv64,
and support for riscv32 is not a priority either,
so does other distro like Debian/Ubuntu and Fedora
that targets riscv64 only and not targets riscv32.

ToDo list
- [ ] Office Suite
- [ ] Web Browser
- [ ] Media Player
- [ ] Run on Real Hardware
- [x] Start Xfce on QEMU
- [x] X11 servers & libraries 
- [x] Bootstrap GCC Toolchain
- [x] Boot on QEMU no Graphic

Building of Hollalinux is starting from Slackware 15.0 release source,
combining some upgrades from the current branch up to August 2022.
Packages from SlackBuilds.org are also planned to be built 
and provided in binary form, since the performance of RISC-V
hardwares and emulators are rather low at the time.

Porting work will be carried out with care 
to not break anything that already running well 
on other architectures supported by Slackware 
such as x86 and arm.
