{
  config,
  lib,
  pkgs,
  hyprland,
  ...
}: {
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # Sans(Serif) fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      (google-fonts.override {fonts = ["Inter"];})

      # monospace fonts
      jetbrains-mono

      # nerdfonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Inter" "Noto Color Emoji"];
      monospace = ["JetBrains Mono" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Allow swaylock to be used by users. Enabled if you use sway,
  # but not for other compositors
  security.pam.services.swaylock = {};

  # Authentication agent
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;

  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["alex"];
  };
}
