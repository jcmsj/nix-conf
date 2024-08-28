{ inputs, pkgs, ... }:
let
  binds = import ./binds.nix;
  rules = import ./windowrules.nix;
  autostart = import ./autostart.nix;
in
{
  imports = [
    ./lock.nix
    ./paper.nix
    ./idle.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
    settings = {
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "HDMI-A-1, 1920x1080@165, 0x0, 1"
        "eDP-1, 1920x1080@60, 1920x0, 1"
        ",highrr,auto,1"
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 0;

        touchpad = {
          natural_scroll = "yes";
          scroll_factor = 0.3;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      "$primary_color" = "rgba(08605Fee)";
      "$inactive_bg" = "rgba(595959aa)";

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        resize_on_border = 1;
        "col.active_border" = "$primary_color rgba(F8B500ee) 45deg";
        "col.inactive_border" = "$inactive_bg";
        layout = "dwindle";
      };

      cursor = {
        no_warps = true;
        # no_hardware_cursors = true;
        # allow_dumb_copy = true;
      };

      group = {
        groupbar = {
          # dont need
          enabled = false;
          "col.active" = "$primary_color";
          "col.inactive" = "$inactive_bg";
        };
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 4;
        drop_shadow = false; # disabled for perf
        # shadow_range = 4;
        # shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        blur = {
          enabled = false; # disabled for perf
        };
      };

      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, myBezier"
          "windowsOut, 1, 4, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 4, default"
        ];
      };
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };
      master = {
        new_status = "master";
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = "on";
      };

      device = [
        {
          name = "logitech-gaming-mouse-g402";
          sensitivity = 0;
          accel_profile = "flat";
        }
        {
          name = "rakk-magan-mouse";
          sensitivity = 0;
          accel_profile = "flat";
        }
        {
          name = "beken-2.4g-wireless-device-1";
          sensitivity = 0;
          accel_profile = "flat";
        }
      ];

      misc = {
        vfr = true;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = false;
      };

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "first current"; # [center/first] [workspace] e.g. first 1 or center m+1
          enable_gesture = true; # laptop touchpad, 4 fingers
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
      };

      # merge other stuff
    } // binds // rules // autostart // {
      env = [
        "HYPRCURSOR_THEME, Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ] ++ binds.env;
    };
  };
}
