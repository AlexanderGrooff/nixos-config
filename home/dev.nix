{
  config,
  pkgs,
  astronvim,
  dotfiles,
  ...
}: {
  home.packages = with pkgs; [
    direnv
    docker-compose
    gcc
    github-cli
    nix-direnv
    openvpn
    podman
    poetry
    syncthing
  ];

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
