{
  config,
  pkgs,
  astronvim,
  ...
}: {
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    alejandra
    calc
    direnv
    dnsutils # `dig` + `nslookup`
    file
    fzf
    github-cli
    gnupg
    htop
    iftop
    inetutils # telnet
    inotify-tools
    iotop
    iperf3
    jq
    lm_sensors # for `sensors` command
    lshw
    lsof
    ltrace # library call monitoring
    mtr
    ncdu
    neofetch
    nix-direnv
    nix-output-monitor
    nmap
    pciutils # lspci
    podman
    ripgrep
    rsync
    strace
    tmux
    tree
    unzip
    usbutils # lsusb
    which
    yq-go
    zip
  ];

  programs.git = {
    enable = true;
    userName = "Alexander Grooff";
    userEmail = "alexandergrooff@gmail.com";
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./dotfiles/.zshrc;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "agnoster";
    };
  };

  xdg.configFile = {
    astronvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = ./dotfiles/nvim;
    };
    nvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = astronvim;
    };
  };

  programs.neovim = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".bash_aliases".source = ./dotfiles/.bash_aliases;
  };
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
