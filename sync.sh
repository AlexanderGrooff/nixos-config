#!/usr/bin/env bash

set -e
set -x

TARGET="10.0.0.26"
HOSTNAME="mu"

nix run github:kamadorueda/alejandra/3.0.0 -- .
git add .
nix flake check
rsync -rd --rsync-path="sudo rsync" --chown=root:root "${PWD}/" $TARGET:/etc/nixos
ssh $TARGET sudo nixos-rebuild switch --flake "/etc/nixos/#$HOSTNAME"
