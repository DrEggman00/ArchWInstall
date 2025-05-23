#!/bin/bash

cp -rv mirrorlist /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux-firmware nano linux grub efibootmgr

echo "Instalação base do Arch Linux instalada"

cp -rv /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

cp -rv /etc/pacman.conf /mnt/etc/pacman.conf

cp -rv ../grub /mnt/etc/default/grub

genfstab -U -p /mnt >> /mnt/etc/fstab

cp -rv *.sh /mnt/

arch-chroot /mnt
