{
  config,
  pkgs,
  astronvim,
  dotfiles,
  unstable,
  ...
}: let
  unstablepkgs = unstable.legacyPackages.${pkgs.system};
in {
  home.packages =
    (with pkgs; [
      direnv
      docker-compose
      gcc
      github-cli
      nix-direnv
      nix-search-cli
      openvpn
      podman
      poetry
      syncthing
    ])
    ++ (with unstablepkgs; [
      podman-compose
    ]);

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
