{ lib, pkgs, ... }:
{
  # For debugging and troubleshooting Secure Boot.
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot"; # ← use the same mount point here.
      };
      systemd-boot = {
        # enable = true;
      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
        enable = lib.mkForce false;
      };
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   # efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      #   device = "nodev";
      #   useOSProber = true;
      #   extraEntries = ''
      #     menuentry "Reboot" {
      #       reboot
      #     }
      #     menuentry "Poweroff" {
      #       halt
      #     }
      #     menuentry "uefi-firmware" {
      #       fwsetup
      #     }
      #   '';
      # };
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    supportedFilesystems = [ "ntfs" ];
  };
}
