#!/bin/bash
cd $(dirname $0) ; CWD=$(pwd)
MNT_SLK=${MNT_SLK:-/mnt/slackware}
DIR_PKG=${DIR_PKT:-$CWD/everything}
DIR_SRC=${DIR_SRC:-$CWD}

echo "installpkg to $MNT_SLK from $DIR_PKG"
installpkg --root $MNT_SLK $DIR_PKG/*
echo "installpkg finished and now ldconfig"
ldconfig -r $MNT_SLK

# root passwd is Slack1@#$5
echo "chpasswd root:Slack1@#\$5"
echo "root:Slack1@#\$5" | chpasswd -R $MNT_SLK

echo "symlink /etc/hostname with /etc/HOSTNAME"
ln -sv HOSTNAME $MNT_SLK/etc/hostname

echo "rename /etc/asciidoc/*.conf.new to *.conf"
rename -v .conf.new .conf $MNT_SLK/etc/asciidoc/*.new
#rename -v login.new login $MNT_SLK/etc/pam.d/login.new

echo "copy /extlinux/extlinux.conf and etc."
cp -rv $DIR_SRC/extlinux	$MNT_SLK/
#cp -r $DIR_SRC/etc	$MNT_SLK/
cp -rv $DIR_SRC/etc/fstab	$MNT_SLK/etc/

echo "enable default /dev/console on QEMU boot"
echo "c0:12345:respawn:/sbin/agetty --noclear 38400 console linux" \
>> $MNT_SLK/etc/inittab

echo "use QEMU DNS nameserver 10.0.2.3 in /etc/resolv.conf"
echo "nameserver 10.0.2.3" \
>  $MNT_SLK/etc/resolv.conf

echo "enable eth0 with dhcp"
#sed -e 's|^USE_DHCP[0]=""|USE_DHCP[0]="yes"|g' \
sed -e 's|^USE_DHCP\[0\]=\"\"|USE_DHCP\[0\]=\"yes\"|g' \
    -i.bak \
    $MNT_SLK/etc/rc.d/rc.inet1.conf

echo "PermitRootLogin yes in /etc/ssh/sshd_config "
echo "PermitRootLogin yes" \
>> $MNT_SLK/etc/ssh/sshd_config

# Since ca-certificates.txz is installed by installpkg --root,
# update-ca-certificates is not executed after installation in
# target file system root. Run update-ca-certificates in chroot
chroot $MNT_SLK update-ca-certificates --fresh
