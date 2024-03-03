#!/usr/bin/env bash

set -e
set -x

nix run github:kamadorueda/alejandra -- .
nix flake check
git add .
rsync -rd --rsync-path="sudo rsync" --chown=root:root "${PWD}/" alex@10.0.0.63:/etc/nixos
ssh alex@10.0.0.63 sudo nixos-rebuild switch --flake "/etc/nixos/#vm2"
