{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # powers up the default Bluetooth controller on boot
  hardware.bluetooth.powerOnBoot = true;
  # TODO: Try home manager service
  # Using Bluetooth headset buttons to control media player
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
