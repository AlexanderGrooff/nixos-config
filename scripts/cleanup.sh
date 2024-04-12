#!/usr/bin/env bash

PROFILE_DIR=/nix/var/nix/profiles

for P in $(ls -1t $PROFILE_DIR | egrep "system.*link" | tail -n+6); do
    echo Deleting $PROFILE_DIR/$P
    sudo rm -v $PROFILE_DIR/$P
done

nix store gc
nix-collect-garbage

echo Done cleaning up old profiles
