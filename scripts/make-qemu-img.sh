#!/bin/bash
cd $(dirname $0) ; CWD=$(pwd)
RAW_IMG=${RAW_IMG:-"slackware-riscv64-15.0.20220910-alfa.rawimg"}
RAW_ARG=${RAW_ARG:-"-s 10G"}
MNT_SLK=${MNT_SLK:-"/mnt/slackware"}
DIR_SRC=${DIR_SRC:-$CWD}
DIR_IMG=${IMG_SLK:-$CWD/RAW_IMG}
DIR_PKG=${DIR_PKT:-$CWD/everything}

################
# dd fallocate truncate
echo "create disk image file: $DIR_IMG"
truncate $RAW_ARG $DIR_IMG

RAW_DEV=$(losetup -fP --show $DIR_IMG)
echo "$RAW_IMG loop mounted at $RAW_DEV"

sgdisk --clear \
       --set-alignment=4096 \
       --new=1:+128M:0 \
       --change-name=1:SYSROOT \
       -- $RAW_DEV
mkfs.btrfs --label SYSROOT ${RAW_DEV}p1

echo "mount ${RAW_DEV}p1 at $MNT_SLK"
mount ${RAW_DEV}p1 $MNT_SLK


################
echo "installpkg to $MNT_SLK from $DIR_PKG"
installpkg --root $MNT_SLK $DIR_PKG/*


################
echo "installpkg finished and now ldconfig"
echo "/lib64" >> $MNT_SLK/etc/ld.so.conf
echo "/usr/lib64" >> $MNT_SLK/etc/ld.so.conf
ldconfig -r $MNT_SLK

# pkgconfig search path
sed -e 's|^export PKG_CONFIG_PATH||g'\
    -i \
    $MNT_SLK/etc/profile.d/pkgconfig.sh
echo 'PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/lib64/pkgconfig:/usr/lib64/pkgconfig' \
>>  $MNT_SLK/etc/profile.d/pkgconfig.sh
echo 'export PKG_CONFIG_PATH' \
>>  $MNT_SLK/etc/profile.d/pkgconfig.sh

echo 'setenv PKG_CONFIG_PATH ${PKG_CONFIG_PATH}:/lib64/pkgconfig:/usr/lib64/pkgconfig' \
>>  $MNT_SLK/etc/profile.d/pkgconfig.csh


################
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
# netconfig
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


################
umount $MNT_SLK
#losetup -d $(losetup -ln -ONAME -j $RAW_IMG)
losetup -d $RAW_DEV

zstd --ultra -22 --rm ${DIR_IMG} -o ${DIR_IMG}.zst
