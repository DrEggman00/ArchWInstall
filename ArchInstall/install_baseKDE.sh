#!/bin/bash
pacman-key --init

pacman-key --init

pacman-key --populate

pacman-key --populate

pacman -Syyuu

ln -sf /usr/share/zoneinfo/America/Araguaina /etc/localtime

echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen

locale-gen

echo "LANG=pt_BR.UTF-8" > /etc/locale.conf

echo "computador" > /etc/hostname

echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch --recheck

grub-mkconfig -o /boot/grub/grub.cfg

echo "Senha do Root"

passwd

echo "Adicionando usuário padrão James"

useradd -m -g users -G wheel,storage,power -s /bin/bash dr

passwd dr

pacman -S dosfstools mtools os-prober networkmanager network-manager-applet wpa_supplicant wireless_tools dialog mesa xorg-xinit xorg-server xorg-apps xf86-video-intel nvidia nvidia-settings konsole plasma firefox nasm git wget curl

echo "dr ALL=(ALL:ALL) ALL" >> /etc/sudoers

systemctl enable NetworkManager

systemctl enable sddm
