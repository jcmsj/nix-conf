{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson_201207w
      gutenprint
      epson-escpr2
      epson-escpr
    ];
  };
  hardware.printers = {
    ensurePrinters = [
      {
        # name & model taken from: `lpinfo -m`
        name = "EPSON_L210";
        model = "epson-inkjet-printer-201207w/ppds/EPSON_L210.ppd";
        #  deviceUri taken from: `lpinfo -v`
        deviceUri = "usb://EPSON/L210%20Series?serial=534D584B3033373006";
        location = "Home";
      }
    ];
  };

  # scanner support
  hardware.sane.enable = true;

  # related program
  environment.systemPackages = with pkgs; [
    naps2
    simple-scan
  ];

  # allow scanner access to user
  users.users.jcsan = {
    extraGroups = [ "scanner" "lp" ];
  };
}
