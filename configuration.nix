# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
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
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";

    # Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      #wayland = false;
    };
    desktopManager.gnome.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];
    firefox.speechSynthesisSupport = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

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
    package = config.boot.kernelPackages.nvidiaPackages.production;
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

  environment.sessionVariables = rec {
    CHROME_EXECUTABLE = "google-chrome-unstable";
  };
  environment.shellAliases = {
    sudo = "sudo ";
    "ls-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jcsan = {
    isNormalUser = true;
    description = "Jean Carlo M. San Juan";
    extraGroups = [ "networkmanager" "wheel" "adbuser" ];
    packages = with pkgs; [
      firefox-bin
      firefox-devedition-bin
      discord
      speechd
      nixpkgs-fmt
      google-chrome-dev
      #  thunderbird
    ];
  };

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
    nvidia-offload
    unstable.gnomeExtensions.appindicator
    unstable.gnomeExtensions.gtk4-desktop-icons-ng-ding
    unstable.gnomeExtensions.dash-to-dock
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
  programs.adb.enable = true;

  # For Piper to work
  services.ratbagd.enable = true;
  # Power Management - https://nixos.wiki/wiki/Laptop
  # services.power-profiles-daemon.enable = false;
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 40;
  #   };
  # };
 
  home-manager.users.jcsan = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
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
