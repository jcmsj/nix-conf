{ inputs, config, pkgs, system,... }:
let 
  SHARED_DRIVE = "/media/kozue";
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
  home.username = "jcsan";
  home.homeDirectory = "/home/jcsan";
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
    "$HOME/.pnpm"
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
          audio = ["audio/*"  "audio/mp3" "audio/flac" "audio/ogg" "audio/wav" "audio/m4a" ];
          players = [ "vlc.desktop" "org.gnome.celluloid.desktop" ];
          imageHandler = {
            items = ["image/*" "image/webp" "image/png" "image/jpeg" "image/gif" "image/jpg"];
            handler = "org.gnome.gThumb.desktop";
          };
          handlerToAttr = list: handler: builtins.listToAttrs (builtins.map (mime: {name = mime; value = handler; }) list);
        in {
          "application/pdf" = "zen-beta.desktop";
          "text/plain" = "org.gnome.TextEditor.desktop";
          "text/*" = "org.gnome.TextEditor.desktop";
          "inode/directory" = "org.gnome.Nautilus.desktop";
        } // (handlerToAttr (video ++ audio) players) 
          // (handlerToAttr imageHandler.items imageHandler.handler);
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
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
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };
  # programs.ags = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     gtksourceview
  #     webkitgtk
  #     accountsservice
  #   ];
  # };
  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [pkgs.firefoxpwa];
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
          "text/html" "text/xml" "application/xhtml+xml"
          "application/xml" "application/rss+xml" "application/atom+xml"
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
  # programs.rofi = {
  #   enable = true;
  #   package = pkgs.rofi-wayland.override {
  #     plugins = [
  #       inputs.rofi-vscode-mode.packages.${pkgs.stdenv.hostPlatform.system}.default
  #     ];
  #   };
  #   # modi: 
  #   extraConfig = {
  #     modi = "drun,run,window,ssh";
  #   };
  # };
}
