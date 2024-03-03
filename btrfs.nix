{
  config,
  lib,
  pkgs,
  ...
}: {
  services.snapper = {
    snapshotRootOnBoot = true;

    configs = {
      # root = {
      #   SUBVOLUME = "/";
      #   ALLOW_USERS = ["alex"];
      #   TIMELINE_CREATE = true;
      #   TIMELINE_CLEANUP = true;
      # };
      # home = {
      #   SUBVOLUME = "/home";
      #   ALLOW_USERS = ["alex"];
      #   TIMELINE_CREATE = true;
      #   TIMELINE_CLEANUP = true;
      # };
    };
  };
}
