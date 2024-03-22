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

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    Standardoutput = "tty";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
  services.gnome = {
    gnome-keyring.enable = true;
  };
}
