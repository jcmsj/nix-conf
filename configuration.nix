# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./bootloader.nix
      ./power.nix
      ./fonts.nix
      ./i18n.nix
      ./de.nix
      ./nvidia.nix
      ./shell-environment.nix
      ./network.nix
      ./sound.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    # Cachix for hyprland - https://wiki.hyprland.org/Nix/Cachix/
    # not using it for now, for maximum perf
    # substituters = ["https://hyprland.cachix.org"];
    # trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config = {
    allowUnfree = true;
    firefox.speechSynthesisSupport = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Automounting external drives
  services.gvfs.enable = true;
  services.udisks2.enable = true; 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jcsan = {
    isNormalUser = true;
    description = "Jean Carlo M. San Juan";
    extraGroups = [ "networkmanager" "wheel" "adbuser" ];
    packages = with pkgs; [

    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ## Required Apps
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # notif daemon
    mako
    libnotify
    # Wallpaper
    # hyprecosystem
    hyprpaper
    hypridle # idle management
    hyprpicker # Color picker
    hyprlock
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

    nerdfonts
    # bar
    eww
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
    wineWowPackages.staging
    wineWowPackages.waylandFull
    bottles-unwrapped
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
    nodejs_21
    nodePackages_latest.pnpm

    php
    (python311.withPackages (ps: with ps; [
      (buildPythonPackage {
        pname = "envycontrol";
        version = "3.4.0";
        src = fetchTarball {
          url ="https://github.com/bayasdev/envycontrol/archive/refs/tags/v3.4.0.tar.gz";
          sha256 = "sha256-m0ZH6kqLg15IfFtmoBqZgEe7wpIde/bIEyn6YY/L/xU=";
        };
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
    gnome.gnome-clocks
    gnome.eog
    health
    authenticator
    
    krita
    neofetch
    inkscape

    firefox-bin
    firefox-devedition-bin
    discord
    speechd
    nixpkgs-fmt
    google-chrome

    qbittorrent
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # For Piper to work
  services.ratbagd.enable = true;

  programs.gamemode.enable = true;

  programs.adb.enable = true;
  services.logind.extraConfig = ''
    # don't shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  nixpkgs.overlays = [

  ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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
 
