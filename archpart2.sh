#!/bin/bash
pacman -Syyu nano dhcpcd man grub os-prober efibootmgr git sudo
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

git clone https://bobby3605/dotfiles/laptop/install.sh
su $user1 ./dotfiles/laptop/install.sh
#
