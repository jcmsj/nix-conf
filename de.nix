{ pkgs, ... }:

{
  programs.nm-applet = {
    enable = true;
  };
  programs.waybar = {
    enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";

    # GDM for lockscreen
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    #desktopManager.gnome.enable = true;
  };

  services.gnome = {
    gnome-keyring.enable = true;
  };

  # services.udev.packages = with pkgs; [
  #   gnome.gnome-settings-daemon
  # ];

  #programs.dconf.enable = true;
}
