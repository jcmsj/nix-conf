{pkgs, ...}:
{
  # https://nixos.wiki/wiki/Syncthing
  services = {
    syncthing = {
      enable = true;
      user = "jcsan";
      dataDir = "/media/sorairo/Docs"; # Default folder for new synced folders
      configDir = "/home/jcsan/.config/syncthing"; # Folder for Syncthing's settings and keys
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "CPH2219" = {
            id = "3VO73XM-6GRD4FQ-Q2FBV3I-4TGBRI4-MOQ25FT-NJKZJ52-2UHPIIZ-N5KF7QI";
          };
        };
        folders = {
          "Books" = {
            # Name of folder in Syncthing, also the folder ID
            id = "uscr9-hyowx";
            path = "/media/sorairo/Light Novels"; # Which folder to add to Syncthing
            devices = [ "CPH2219" ]; # Which devices to share the folder with
            ignorePerms = true;
          };
          "Music" = {
            id = "dgagj-ckacd";
            path = "/media/sorairo/Music";
            devices = [ "CPH2219" ];
            ignorePerms = true; 
          };
        };
      };
    };
  };
  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  environment.systemPackages = with pkgs; [
    syncthingtray
  ];

}
