#!/bin/bash
fdisk -l
echo -e "\nEnter disk location, all contents will be wiped"
read disk
umount "$disk""1"
umount "$disk""2"
# Format partitions, \n for every enter
echo -e "g\nn\n\n\n+512M\nn\n\n\n\nw\n" | fdisk $disk
echo -e "t\n1\n1\nw\n" | fdisk $disk
mkfs.fat -F32 "$disk""1"
mkfs.ext4 "$disk""2"
mount "$disk""1" /mnt/boot
mount "$disk""2" /mnt
cp mirrorlist /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cp mirrorlist /mnt/etc/pacman.d/mirrorlist
cp locale.gen /mnt/etc/locale.gen
chmod +x archpart2.sh
cp archpart2.sh /mnt/root/
arch-chroot /mnt /root/archpart2.sh

#
