{pkgs, ...}:

{
  imports = [
      <home-manager/nixos>
  ];
    home-manager.users.jcsan = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
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

    programs.obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    };

  };
}
