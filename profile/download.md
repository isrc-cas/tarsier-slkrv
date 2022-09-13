# HollaLinux Download

The HollaLinux project has released a riscv64 port of Slackware that is Xfce4 ready,
though with very limited desktop applications.

https://repo.tarsier-infra.com/Slackware-RISC-V/slackware-riscv64/15.0.20220825-alfa/qemu-img/

The start script contains some useful information. Read it before run it.

QEMU SDL graphics is of course not useable on a headless host machine,
disable it in the start script to run QEMU console only,
or use other graphics like VNC and so on.

Edit `/etc/resolv.conf` to have a functional network if name resolving problems are encountered,
or issue `netconfig` that comes with Slackware as the default network configuring tool.
