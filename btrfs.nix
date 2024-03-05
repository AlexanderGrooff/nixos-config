{
  config,
  lib,
  pkgs,
  ...
}: {
  # services.btrbk.instances = {
  #   home.settings = {
  #     snapshot_preserve = "14d";
  #     volume = {
  #       "/" = {
  #         subvolume = {
  #           home = {
  #             snapshot_create = "always";
  #           };
  #         };
  #         target = "/backup/${config.networking.hostName}/home";
  #       };
  #     };
  #   };
  # };
}
