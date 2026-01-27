#!/bin/bash

set -Eeuo pipefail

source ./config.conf

loadkeys "$KEYMAP"
setfont ter-v32n
timedatectl set-ntp true

echo ">> Particionando disco $DISK"
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+1G -t 1:ef00 "$DISK"
sgdisk -n 2:0:-25G -t 2:8300 "$DISK"
sgdisk -n 3:0:0 -t 3:8200 "$DISK"
partprobe "$DISK"

echo ">> Formatando"
mkfs.vfat -F32 "$EFI_PART"
mkfs.btrfs -f "$ROOT_PART"
mkswap "$SWAP_PART"
swapon "$SWAP_PART"

echo ">> Montando"
mount "$ROOT_PART" /mnt
mount --mkdir "$EFI_PART" /mnt/efi

echo ">> Instalando sistema base"
pacstrap -K /mnt \
  base base-devel linux linux-firmware \
  grub efibootmgr intel-ucode \
  networkmanager plasma-meta sddm \
  nano vim bitwarden nasm

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
arch-chroot /mnt hwclock --systohc

arch-chroot /mnt sed -i "s/^#\($LOCALE UTF-8\)/\1/" /etc/locale.gen
arch-chroot /mnt locale-gen


echo "LANG=$LOCALE" > /mnt/etc/locale.conf
echo 'KEYMAP="$KEYMAP"' > /mnt/etc/vconsole.conf
echo "$HOSTNAME" > /mnt/etc/hostname

arch-chroot /mnt systemctl enable NetworkManager sddm

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$USERNAME"

arch-chroot /mnt passwd

arch-chroot /mnt passwd "$USERNAME"

echo "%wheel ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/wheel
chmod 440 /mnt/etc/sudoers.d/wheel