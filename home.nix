{ inputs, config, pkgs, system, lib, ... }:
let
  SHARED_DRIVE = "/media/kozue";
  username = "jcsan";
  homeDirectory = "/home/${username}";
  userDirs =
    {
      documents = "${SHARED_DRIVE}/docs";
      videos = "${SHARED_DRIVE}/Videos";
      music = "${SHARED_DRIVE}/music";
      pictures = "${SHARED_DRIVE}/Pictures";
      download = "${SHARED_DRIVE}/downloads";
    };
in
{
  imports = [
    # inputs.ags.homeManagerModules.default
    inputs.zen-browser.homeModules.beta
    # ./hypr/hyprland.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDirectory;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # Only change this value if doing a fresh install of NixOS
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    # (pkgs.callPackage ./osu-lazer.nix {})
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  home.sessionPath = [
    # for pnpm to work
    "${homeDirectory}/.pnpm"
  ];
  services.mpd-mpris.enable = true;
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
    } // userDirs;

    mimeApps = {
      enable = true;
      defaultApplications =
        let
          video = [ "video/*" "video/mp4" "video/x-matroska" "video/mkv" "video/webm" "video/avi" "video/ogg" ];
          audio = [ "audio/*" "audio/mp3" "audio/flac" "audio/ogg" "audio/wav" "audio/m4a" ];
          players = [ "vlc.desktop" "org.gnome.celluloid.desktop" ];
          imageHandler = {
            items = [ "image/*" "image/webp" "image/png" "image/jpeg" "image/gif" "image/jpg" ];
            handler = "org.gnome.gThumb.desktop";
          };
          handlerToAttr = list: handler: builtins.listToAttrs (builtins.map (mime: { name = mime; value = handler; }) list);
        in
        {
          "application/pdf" = "zen-beta.desktop";
          "text/plain" = "org.gnome.TextEditor.desktop";
          "text/*" = "org.gnome.TextEditor.desktop";
          "inode/directory" = "org.gnome.Nautilus.desktop";
        } // (handlerToAttr (video ++ audio) players)
        // (handlerToAttr imageHandler.items imageHandler.handler);
    };
  };

  home.pointerCursor = {
    enable = true;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 22;
    gtk.enable = true;
    x11.enable = true;
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-moon";
    };
    iconTheme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-icon-theme;
    };
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 22;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk3.bookmarks =
      # <file://> + <xdg dir path>
      builtins.map (dir: "file://${userDirs.${dir}}") (builtins.attrNames userDirs)
      ++ [
        # add others here
        "file://${SHARED_DRIVE}/sync"
        "file://${SHARED_DRIVE}/Light%20Novels"
        "file://${SHARED_DRIVE}/anime"
        "file://${homeDirectory}/code"
      ];
  };
  # Prefer dark theme
  # dconf = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
  };
  programs.git = {
    enable = true;
    userName = "Jean Carlo San Juan";
    userEmail = "sanjuan.jeancarlo@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
      cam = "commit -am";
      cm = "commit -m";
      uncommit = "reset HEAD~1";
      recommit = "commit --amend --no-edit";
      edit = "commit --amend";
      undo = "uncommit";
      redo = "recommit";
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 15000;
    history.path = "${config.home.homeDirectory}/zsh/history";
    initContent = ''
      bindkey '^H' backward-kill-word
    '';
  };
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka";
    };
    settings = {
      enabled_layouts = "tall:bias=50;full_size=1;mirrored=false";
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+f>2" = "set_font_size 20";
      "ctrl+f5" = "launch --location=hsplit";
      "ctrl+f6" = "launch --location=vsplit";
      "ctrl+f4" = "launch --location=split";
      "ctrl+f7" = "layout_action rotate";
      "ctrl+left" = "neighboring_window left";
      "ctrl+right" = "neighboring_window right";
      "ctrl+up" = "neighboring_window up";
      "ctrl+down" = "neighboring_window down";
    };
  };
  programs.obs-studio = {
    package = (pkgs.obs-studio.override {
      cudaSupport = true;
    });
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      # find more options here: https://mozilla.github.io/policy-templates/
    };
  };

  xdg.desktopEntries =
    let
      ZEN_PROFILE_DIR = "${config.home.homeDirectory}/.zen";
      PROFILE_IDS = [
        { id = "j5n30c02.grit"; name = "Grit"; }
        { id = "vd47b3qr.Work"; name = "Work"; }
      ];
      ZEN_EXE = "${inputs.zen-browser.packages.${system}.beta}/bin/zen-beta";
      mkEntry = profile: {
        name = "zen:${profile.name} Profile";
        exec = "${ZEN_EXE} --profile ${ZEN_PROFILE_DIR}/${profile.id}";
        icon = "zen-beta";
        type = "Application";
        categories = [ "Network" "WebBrowser" ];
        startupNotify = true;
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/xml"
          "application/rss+xml"
          "application/atom+xml"
          "application/pdf"
        ];
      };
    in
    builtins.listToAttrs (
      builtins.map
        (profile: {
          name = profile.name;
          value = mkEntry profile;
        })
        PROFILE_IDS
    );
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    # still broken
    # extraConfig =
    #   {
    #     modi = (lib.concatStringsSep "," [
    #       "run"
    #       "drun"
    #       "window"
    #       "ssh"
    #       "emoji"
    #       "vscode-recent:${inputs.rofi-vscode-mode.packages.${system}.default}/bin/vscode-recent"
    #     ] );
    #   };
  };
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
      { event = "lock"; command = "lock"; }
    ];
    timeouts = [
      { timeout = 60; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
      { timeout = 90; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Background and image settings
      color = "1a0a1a"; # Deep dark purple/black background
      image = "/home/jcsan/Wallpapers/AyaMaruyama.png";
      scaling = "fill"; # Image scaling mode: stretch, fill, fit, center, tile, solid_color
      
      # Effects to enhance the magical/fantasy aesthetic
      effect-blur = "7x5"; # Blur the image (radius x times)
      effect-vignette = "0.3:0.7"; # Apply vignette effect (base:factor, 0-1)
      
      # Clock and indicator settings
      clock = true; # Show time and date
      timestr = "%I:%M:%S %p"; # 12-hour format with AM/PM
      datestr = "%B %d, %Y"; # Full date format
      
      # Indicator appearance and behavior
      indicator = true; # Always show the indicator
      indicator-radius = 120; # Sets the indicator radius
      indicator-thickness = 8; # Sets the indicator thickness
      indicator-caps-lock = true; # Show Caps Lock state on indicator
      indicator-idle-visible = true; # Show indicator even when idle
      
      # Additional indicator settings
      show-keyboard-layout = true; # Display current xkb layout while typing
      show-failed-attempts = true; # Show count of failed attempts
      
      # Ring colors (outer circle of indicator)
      ring-color = "e91e63"; # Vibrant pink for normal state
      ring-ver-color = "9c27b0"; # Purple when verifying password
      ring-wrong-color = "f44336"; # Red for wrong password
      ring-clear-color = "673ab7"; # Deep purple when cleared
      ring-caps-lock-color = "ff9800"; # Orange when Caps Lock is active
      
      # Inside colors (inner circle of indicator)
      inside-color = "2a1a2aee"; # Darker purple, more opaque
      inside-ver-color = "9c27b0ee"; # Purple with high opacity for verification
      inside-wrong-color = "f44336ee"; # Red with high opacity for wrong password
      inside-clear-color = "673ab7ee"; # Deep purple with high opacity for clear
      inside-caps-lock-color = "ff9800ee"; # Orange when Caps Lock is active
      
      # Line colors (between inside and ring)
      line-color = "e91e6366"; # Pink separator, semi-transparent
      line-ver-color = "9c27b0aa"; # Purple for verification
      line-wrong-color = "f44336aa"; # Red for wrong password
      line-clear-color = "673ab7aa"; # Deep purple for clear
      line-caps-lock-color = "ff9800aa"; # Orange when Caps Lock is active
      
      # Text colors
      text-color = "ffffff"; # White text for normal state
      text-ver-color = "ffffff"; # White verification text
      text-wrong-color = "ffffff"; # White wrong password text
      text-clear-color = "ffffff"; # White clear text
      text-caps-lock-color = "ffffff"; # White text when Caps Lock is active
      
      # Key highlight colors
      key-hl-color = "ff6ec7"; # Bright pink highlight for key presses
      caps-lock-key-hl-color = "ffc107"; # Yellow highlight when Caps Lock is active
      bs-hl-color = "f44336"; # Red highlight for backspace
      caps-lock-bs-hl-color = "ff5722"; # Orange-red backspace when Caps Lock is active
      
      # Separator color
      separator-color = "e91e6355"; # Light pink separator
      
      # Font settings
      font = "Iosevka"; # Match your terminal font
      font-size = 22; # Fixed font size for indicator text
      
      # Layout text colors (for keyboard layout display)
      layout-text-color = "ffffff"; # White layout text
      layout-bg-color = "00000088"; # Semi-transparent background
      layout-border-color = "e91e63"; # Pink border
      
      # Animation and behavior
      fade-in = 0.3; # Smooth fade-in effect
      grace = 3; # 3 seconds grace period
      grace-no-mouse = true; # Require key press, not mouse during grace
      ignore-empty-password = true; # Don't validate empty passwords
      
      # Disable caps lock text (we use indicator instead)
      disable-caps-lock-text = true;
    };
  };
}
