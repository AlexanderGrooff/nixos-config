# NixOS configs

Setting up a machine from ISO:

```bash
export HOSTNAME_TO_INSTALL=blabla

# GPT
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root btrfs 512MB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 2 esp on
mkfs.btrfs -L nixos /dev/sda1
mkfs.fat -F 32 -n boot /dev/sda2

# MBR
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB 100%
mkfs.btrfs -L nixos /dev/sda1

# All cases
mount /dev/disk/by-label/nixos /mnt
btrfs subvolume create /mnt/@{root,home,nix,log}
umount /mnt
mount -o subvol=@root /dev/disk/by-label/nixos /mnt

# GPT
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# All cases from here
mkdir -p /mnt/{etc,home,nix,var/log}
mount -o subvol=@home /dev/disk/by-label/nixos /mnt/home
mount -o subvol=@nix /dev/disk/by-label/nixos /mnt/nix
mount -o subvol=@log /dev/disk/by-label/nixos /mnt/var/log
nixos-generate-config --root /mnt

mv /mnt/etc/nixos{,.old}
nix-shell -p git

git clone https://github.com/AlexanderGrooff/nixos-config.git /mnt/etc/nixos
exit

# CHOOSE GPT/MBR
cp -ra /mnt/etc/nixos/hosts/templates/mbr /mnt/etc/nixos/hosts/$HOSTNAME_TO_INSTALL
sed -i "s/CHANGEME/$HOSTNAME_TO_INSTALL/g" /mnt/etc/nixos/hosts/$HOSTNAME_TO_INSTALL/hostname.nix
cp /mnt/etc/nixos.old/hardware-configuration.nix /mnt/etc/nixos/hosts/$HOSTNAME_TO_INSTALL/hardware-configuration.nix

# Typically copy from vm2 and change hostname
vim /mnt/etc/nixos/flake.nix

cd /mnt/etc/nixos
nix-shell -p git

git add .
nixos-install --flake "/mnt/etc/nixos#$HOSTNAME_TO_INSTALL"
exit

reboot
```
