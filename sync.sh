#!/usr/bin/env bash

set -e
set -x

rsync --rsync-path="sudo rsync" configuration.nix alex@10.0.0.63:/etc/nixos/configuration.nix
ssh alex@10.0.0.63 sudo nixos-rebuild switch
