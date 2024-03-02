{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hostname.nix
    ./hardware-configuration.nix
  ];
}
