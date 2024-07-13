{ pkgs, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    extraHosts = ''
      104.16.26.34 registry.npmjs.org
    '';
  };
  # To be able to use wpa_gui or wpa_cli as user put the following in your
  # networking.wireless.userControlled.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # wifi gui
  programs.nm-applet = {
    enable = true;
  };

  # Bluetooth related
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # powers up the default Bluetooth controller on boot
  hardware.bluetooth.powerOnBoot = true;
  # Using Bluetooth headset buttons to control media player
  # TODO: Try home manager service
  # https://wiki.nixos.org/wiki/Bluetooth
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
  
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
}
