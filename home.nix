{ pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];
  home-manager.extraSpecialArgs = { inherit pkgs; };
  home-manager.useGlobalPkgs = true;
  home-manager.users.jcsan = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.11";

    #  Bluetooth device audio control
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
      gtk3.bookmarks = [
        "file:///media/sorairo/Light%20Novels"
      ];
    };
    programs.home-manager.enable = true;
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
        name = "Fira Code";
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

  };
}
