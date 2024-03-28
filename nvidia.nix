{ pkgs, lib, config, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors 
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    prime = {
      reverseSync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Find it using `lspci -c display`
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
  nixpkgs.config.packageOverrides.nvidia-offload = nvidia-offload;
  # External display
  specialisation = {
    optimus-prime.configuration = {
      system.nixos.tags = [ "OPTIMUS-PRIME" ];
      hardware.nvidia = {
        prime = {
          reverseSync.enable = lib.mkForce true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          } ;
        };
      };
    };
  };
}
