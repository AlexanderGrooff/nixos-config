{
  config,
  pkgs,
  astronvim,
  dotfiles,
  ...
}: {
  home.username = "alex";
  home.homeDirectory = "/home/alex";

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
    gcc
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
    # They are deprecating string input in extraConfig so I'm forced to do it like this
    includes = [{path = "${dotfiles}/.gitconfig";}];
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile "${dotfiles}/.zshrc";
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  programs.ssh = {
    enable = true;
    includes = ["~/.ssh/config.d/*"];
  };

  programs.neovim = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile "${dotfiles}/.tmux.conf";
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.open
      tmuxPlugins.prefix-highlight
    ];
  };

  xdg.configFile = {
    astronvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = "${dotfiles}/.config/nvim";
    };
    nvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = astronvim;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".bash_aliases".source = "${dotfiles}/.bash_aliases";
    ".gitignore_global".source = "${dotfiles}/.gitignore_global";
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
