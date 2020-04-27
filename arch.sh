#!/bin/bash
fdisk -l
echo "Enter disk location, all contents will be wiped"
read disk
# Format partitions, \n for every enter
echo -e "g\nn\n1\n\n+512M\nt\n\1\nn\n\n\nw\n" | fdisk $disk
mkfs.fat -F32 "$disk""1"
mkfs.ext4 "$disk""2"
mount "$disk""1" /mnt
cp mirrorlist /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware nano dhcpcd man grub os-prober efibootmgr git sudo
mount "$disk""2" /mnt/boot
genfstab -U /mnt >> /mnt/etc/fstab
cp mirrorlist /mnt/etc/pacman.d/mirrorlist
cp locale.gen /mnt/etc/locale.gen
arch-chroot /mnt
systemctl enable dhcpcd
###ENTER TIMEZONE
echo "Enter timezone in Region/City format"
read timezone
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen
touch /etc/hostname
echo "Enter hostname"
read host
echo $host >> /etc/hostname
echo "127.0.0.1  localhost\n::1 localhost\n127.0.1.1  $host.localdomain $host"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "Enter root password"
passwd root
echo "Enter new user name"
read user1
useradd -m -G sudo $user1
echo "Enter password"
passwd $user1

#End of arch install

#
