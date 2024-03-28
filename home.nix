{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jcsan";
  home.homeDirectory = "/home/jcsan";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jcsan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  home.sessionPath = [
    "$HOME/.pnpm"
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.mpd-mpris.enable = true;
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      documents = "/media/sorairo/Docs";
      videos = "/media/sorairo/Videos";
      music = "/media/sorairo/Music";
      pictures = "/media/sorairo/Pics";
    };
    
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = "firefox-devedition.desktop";
        "inode/directory" = "nautilus.desktop";
      };
      defaultApplications = {
        "text/plain"= "org.gnome.TextEditor.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "image/png" = "eog.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/gif" = "eog.desktop";
        "image/jpg" = "eog.desktop";
      };
    };
  };
  /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      # package = pkgs.graphite-gtk-theme.override {
      # colorVariants = ["dark"];
      # themeVariants = [ "green" ];
      # };
      # name = "graphite-gtk-dark";
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    gtk3.bookmarks = [
      "file:///media/sorairo/Light%20Novels"
    ];
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
      ac = "commit -am";
      uncommit = "reset HEAD~1";
      recommit = "commit --amend --no-edit";
      edit = "commit --amend";
      undo = "uncommit";
      redo = "recommit";
    };
  };
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka";
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+f>2" = "set_font_size 20";
    };
  };
  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
