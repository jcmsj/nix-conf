# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_PH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_PH.UTF-8";
    LC_IDENTIFICATION = "en_PH.UTF-8";
    LC_MEASUREMENT = "en_PH.UTF-8";
    LC_MONETARY = "en_PH.UTF-8";
    LC_NAME = "en_PH.UTF-8";
    LC_NUMERIC = "en_PH.UTF-8";
    LC_PAPER = "en_PH.UTF-8";
    LC_TELEPHONE = "en_PH.UTF-8";
    LC_TIME = "en_PH.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {

    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

  };

  environment.sessionVariables = rec {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-GO";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_OPTIMUS = "NVIDIA_only";
  };
  environment.shellAliases = {
    sudo = "sudo ";
    "list-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jcsan = {
    isNormalUser = true;
    description = "Jean Carlo M. San Juan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox-bin
      firefox-devedition-bin
      discord
      speechd
      nixpkgs-fmt
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.speechSynthesisSupport = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ## Required Apps
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim
    wget
    vlc
    piper
    ## System utils
    htop
    glxinfo
    lshw
    gnomeExtensions.appindicator

    ## Gaming
    lutris
    # support 32-bit only
    wine
    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })
    wineWowPackages.stable
    # wine-staging (version with experimental features)
    wineWowPackages.staging
    # winetricks (all versions)
    winetricks
    #nvtop
    gamescope

    ## Development
    ### Editors
    unstable.vscode
    unstable.vscode-fhs

    ### Version Control
    unstable.gh
    git

    ### Language Runtimes & Managers
    unstable.nodejs_20
    nodePackages.pnpm
    php
  ];

  # For Piper to work
  services.ratbagd.enable = true;

  home-manager.users.jcsan = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    nixpkgs.config = {
      allowUnfree = true;
    };
    programs.git = {
      enable = true;
      userName = "Jean Carlo San Juan";
      userEmail = "sanjuan.jeancarlo@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
        ac = "commit -am";
        uncommit = "reset HEAD~1";
        recommit = "commit --amend --no-edit";
        edit = "commit --amend";
        undo = "uncommit";
        redo = "recommit";
      };
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome.totem
    gnome-tour
    gnome.gnome-music
    epiphany
  ]);

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];
  #programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
