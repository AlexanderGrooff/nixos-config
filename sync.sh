#!/usr/bin/env bash

set -e
set -x

# Get TARGET and HOSTNAME from the environment
HOSTNAME=${HOSTNAME:-$(hostname)}

nix run github:kamadorueda/alejandra/3.0.0 -- .
git add .
nix flake check

if [ -z "$TARGET" ]; then
    sudo rsync -rd "${PWD}/" /etc/nixos
    sudo nixos-rebuild switch --flake "/etc/nixos/#$HOSTNAME"
    bash /etc/nixos/cleanup.sh
else
    rsync -rd --rsync-path="sudo rsync" --chown=root:root "${PWD}/" $TARGET:/etc/nixos
    ssh $TARGET sudo nixos-rebuild switch --flake "/etc/nixos/#$HOSTNAME"
    ssh bash /etc/nixos/cleanup.sh
fi
