{
  config,
  pkgs,
  inputs,
  unstable,
  ...
}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    vim
    zsh
  ];
  programs.ssh = {
    startAgent = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0" # Obsidian
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
