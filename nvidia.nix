{ pkgs, lib, config, ... }:
# https://wiki.nixos.org/wiki/Nvidia
{
  nixpkgs.config.packageOverrides = pkgs: 
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
    nvidia-offload = nvidia-offload;
    # See https://nixos.wiki/wiki/Accelerated_Video_Playback
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  # Make sure opengl is enabled
  hardware.graphics = {
    enable = true;
    # package = pkgs.mesa.drivers;
    extraPackages = with pkgs; [ 
      intel-media-driver   # LIBVA_DRIVER_NAME=iHD
      intel-ocl 
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
  # end of Accelerated Video Playback

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors 
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    prime = {
      sync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Find it using `lshw -c display`
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
  environment.sessionVariables = {
    # AQ_DRM_DEVICES = "$HOME/.config/hypr/intel:$HOME/.config/hypr/nvidia";
  };
  # External display
  specialisation = {
    optimus-prime.configuration = {
      system.nixos.tags = [ "OPTIMUS-PRIME" ];
      hardware.nvidia = {
        prime = {
          # reverseSync.enable = lib.mkForce true; #does not work w/ hyprland yet
          sync.enable = lib.mkForce true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
      };
      environment.sessionVariables = {
        # AQ_DRM_DEVICES = lib.mkForce "$HOME/.config/hypr/nvidia";
      };
      # blacklist intel gpu driver
      boot.kernelParams = [ "module_blacklist=i915" ];
    };

    intel-only.configuration = {
      system.nixos.tags = [ "INTEL-ONLY" ];
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
    };
  };
}
