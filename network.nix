{ pkgs, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # extraHosts = ''
    #   104.16.26.34 registry.npmjs.org
    # '';
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
  # To be able to use wpa_gui or wpa_cli as user put the following in your
  # networking.wireless.userControlled.enable = true;
  # systemd.services.NetworkManager-wait-online.enable = false;
  # services.mullvad-vpn.enable = true;

  # wifi gui
  programs.nm-applet = {
    enable = true;
  };
}
