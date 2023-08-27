{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";

    # Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      #wayland = false;
    };
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome.totem
    gnome-tour
    gnome.gnome-music
    epiphany
  ]);

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  #programs.dconf.enable = true;
}
