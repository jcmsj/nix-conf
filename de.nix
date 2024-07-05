{ inputs, pkgs, ... }:
{
  # https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      variant = "";
      layout = "us";
    };
    # GDM for lockscreen
    # displayManager.gdm = {
    #   enable = true;
    #   wayland = true;
    # };
    #desktopManager.gnome.enable = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "jcsan";
      };
    };
  };
  # security.pam.services.greetd.enableGnomeKeyring = true;
  services.gnome = {
    core-utilities.enable = true;
    gnome-keyring.enable = true;
    sushi.enable = true;
    gnome-online-accounts.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # hyprecosystem
    hyprpaper
    hypridle # idle management
    hyprpicker # Color picker
    hyprlock
    # https://github.com/hyprwm/contrib?tab=readme-ov-file#nix
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    # gnome apps
    # libsecret
    libsForQt5.qt5ct
    # gnome.libgnome-keyring
    gnome.gnome-system-monitor
    gnome.nautilus
    gnome.cheese
    gnome.simple-scan
    gnome-text-editor
    gnome.gnome-clocks
    gnome.eog
    gnome.sushi
    gnome.gnome-calendar
    gnome-online-accounts
    gnome-online-accounts-gtk
    gnome-decoder
    gnome.gnome-calculator
    gnome.gnome-sound-recorder
    gthumb
    amberol
    gparted
    varia
    health
    authenticator
    gnome.ghex

    # For nvidia
    egl-wayland
  ];
}
