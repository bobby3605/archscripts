#!/bin/bash
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen
pacman -Syyu --noconfirm nano dhcpcd man grub os-prober efibootmgr git sudo
systemctl enable dhcpcd
###ENTER TIMEZONE
ls /usr/share/zoneinfo/
echo "Choose Region for Timezone"
read region
ls /usr/share/zoneinfo/$region
echo "Choose City for Timezone"
read city
ln -sf /usr/share/zoneinfo/"$region""$city" /etc/localtime
hwclock --systohc
touch /etc/hostname
echo "Enter hostname"
read host
echo $host >> /etc/hostname
echo -e "127.0.0.1  localhost\n::1 localhost\n127.0.1.1  $host.localdomain $host"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "Enter root password"
passwd root
echo "Enter new user name"
read user1
useradd -m -s /bin/bash $user1
echo "Enter password"
passwd $user1
groupadd -r autologin
gpasswd -a $user1 autologin

#Add to sudoers
sed -i '80s/.*/'$user1' ALL=(ALL) ALL/' /etc/sudoers

git clone https://github.com/bobby3605/dotfiles
su $user1 dotfiles/laptop/install.sh
#
