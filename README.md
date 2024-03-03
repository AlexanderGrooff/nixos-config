# NixOS configs

Setting up a machine from ISO:

```bash
# export HOSTNAME_TO_INSTALL=blabla

# parted /dev/sda -- mklabel msdos
# parted /dev/sda -- mkpart primary 1MB 100%
# mkfs.btrfs -L nixos /dev/disk/by-label/nixos

# btrfs subvolume create /mnt/{root,etc,home,nix,var/log}
# mkdir -p /mnt/{etc,home,nix,var/log}

# mount -o subvol=/root /dev/disk/by-label/nixos /mnt
# mount -o subvol=/etc /dev/disk/by-label/nixos /mnt/etc
# mount -o subvol=/home /dev/disk/by-label/nixos /mnt/home
# mount -o subvol=/nix /dev/disk/by-label/nixos /mnt/nix
# mount -o subvol=/log /dev/disk/by-label/nixos /mnt/var/log

# nixos-generate-config --root /mnt
# mv /mnt/etc/nixos{,.old}

# nix-shell -p git
# git clone https://github.com/AlexanderGrooff/nixos-configs.git /mnt/etc/nixos
# exit
# cp /mnt/etc/nixos.old/hardware-configuration.nix /mnt/etc/nixos/hosts/$HOSTNAME_TO_INSTALL/hardware-configuration.nix

# vim /mnt/etc/nixos/configuration.nix
# nixos-install --flake "/mnt/etc/nixos#$HOSTNAME_TO_INSTALL"

# reboot
```
