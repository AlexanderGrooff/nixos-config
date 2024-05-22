{
  config,
  pkgs,
  astronvim,
  dotfiles,
  unstable,
  ...
}: {
  home.packages = with pkgs;
    [
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
    ]
    ++ (with unstable; [
      podman-compose
    ]);

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
