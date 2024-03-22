{ pkgs, config, ... }:

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
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors 
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # powerManagement.enable = true;
    prime = {
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
  #specialisation = {
  #  external-display.configuration = {
  #    system.nixos.tags = [ "external-display" ];
  #    hardware.nvidia = {
  #      prime.offload.enable = lib.mkForce false;
  #      powerManagement.enable = lib.mkForce false;
  #    };
  #  };
  #};
}
