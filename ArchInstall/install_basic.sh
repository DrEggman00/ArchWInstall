#!/bin/bash

mkfs.vfat -F32 /dev/nvme0n1p1

mkfs.ext4 /dev/nvme0n1p2

echo "Montando partições"

mount /dev/nvme0n1p2 /mnt

mkdir /mnt/efi

mount /dev/nvme0n1p1 /mnt/efi

cp -rv mirrorlist /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux-firmware nano linux grub efibootmgr

echo "Instalação base do Arch Linux instalada"

cp -rv /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

cp -rv /etc/pacman.conf /mnt/etc/pacman.conf

genfstab -U -p /mnt >> /mnt/etc/fstab

cp -rv *.sh /mnt/

arch-chroot /mnt
