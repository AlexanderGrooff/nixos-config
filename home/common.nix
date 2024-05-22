{
  config,
  pkgs,
  astronvim,
  dotfiles,
  ...
}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    alejandra
    calc
    dnsutils # `dig` + `nslookup`
    fzf
    gnupg
    iftop
    inetutils # telnet
    inotify-tools
    iotop
    iperf3
    jq
    lm_sensors # for `sensors` command
    lsof
    ltrace # library call monitoring
    neofetch
    openssl
    ripgrep
    strace
    tmux
    yq-go
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
    "bin".source = "${dotfiles}/bin";
    "scripts".source = "${dotfiles}/scripts";
  };
}
