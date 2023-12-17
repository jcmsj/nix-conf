{pkgs, ...}:
{
  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # powers up the default Bluetooth controller on boot
  hardware.bluetooth.powerOnBoot = true;
  # Using Bluetooth headset buttons to control media player
  # TODO: Try home manager service
  # https://nixos.wiki/wiki/Bluetooth
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
  # To be able to use wpa_gui or wpa_cli as user put the following in your
  networking.wireless.userControlled.enable = true;
}
