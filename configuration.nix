# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./i18n.nix
      ./power.nix
      ./de.nix
      ./nvidia.nix
      ./home.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Bootloader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
      };
      grub = {
        enable = true;
        efiSupport = true;
        #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
        device = "nodev";
        useOSProber = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    firefox.speechSynthesisSupport = true;
    # packageOverrides = pkgs: {
    #   unstable = import unstableTarball {
    #     config = config.nixpkgs.config;
    #   };
    # };
  };

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.sessionVariables = rec {
    CHROME_EXECUTABLE = "google-chrome-unstable";
    # If cursor becomes invisible
    #WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    #NIXOS_OZONE_WL = "1";
  };
  environment.shellAliases = {
    sudo = "sudo ";
    "ls-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
    py = "python";
  };

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

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
    home-manager
    # notif daemon
    mako
    libnotify
    # Wallpaper
    hyprpaper

    #Clipboards
    cliphist
    wl-clip-persist

    # hyprland's default terminal
    kitty
    # App launcher
    rofi-wayland

    networkmanagerapplet
    blueman

    #Screenshot Utility
    grim
    slurp
    swappy
    # Color picker
    hyprpicker
    nerdfonts
    # bar
    eww-wayland
    playerctl
    vim
    wget
    vlc
    piper
    ## System utils
    htop
    glxinfo
    lshw
    nvidia-offload
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
    p7zip
    inkscape
    jq
    brightnessctl
    socat
    ## Development
    ### Editors
    vscode
    vscode-fhs

    ### Version Control
    gh
    git

    ### Language Runtimes & Managers
    nil
    nodejs_20
    nodePackages.pnpm

    php
    (python311.withPackages (ps: with ps; [
      (buildPythonPackage {
        pname = "envycontrol";
        version = "3.2.0";
        src = fetchTarball "https://github.com/bayasdev/envycontrol/archive/refs/tags/v3.2.0.tar.gz";
        doCheck = false;
        propogatedBuildInputs = [

        ];
      })
    ]))

    gnome.gnome-system-monitor
    gnome.nautilus
    gnome-photos
    gnome.cheese
    gnome.simple-scan
    gnome-text-editor

    neofetch
  ];

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerdfonts
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Roboto" ];
        monospace = [ "Fira Code" ];
        serif = [ "Noto Fonts CJK" "Fira Code" ];
        emoji = ["noto-fonts-emoji"];
      };
    };
  };
  programs.adb.enable = true;

  # For Piper to work
  services.ratbagd.enable = true;

  programs.gamemode.enable = true;

  nixpkgs.overlays = [
    # (final: prev: {
    #   inkscape = prev.inkscape.overrideAttrs
    #     (old: rec {
    #       version = "1.3";
    #       src = fetchTarball {
    #         url = "https://media.inkscape.org/dl/resources/file/inkscape-${version}.tar.xz";
    #         sha256 = "1gp0ay0kpy4nvgr98p535pqnzj5s2ryh552dpcxgx74grl0zrqfy";
    #       };
    #       buildInputs = old.buildInputs ++ [
    #         pkgs.double-conversion
    #         pkgs.libepoxy
    #       ];
    #     });
    # })
  ];
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
  system.stateVersion = "24.05"; # Did you read the comment?
}
 