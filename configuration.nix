# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, system, ... }:
let
  reisen = pkgs.callPackage ./reisen/reisen.nix { };
  pnpm-shim = pkgs.callPackage ./pnpm-shim.nix { };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./bootloader.nix
      ./power.nix
      ./fonts.nix
      ./language.nix
      # ./de.nix
      ./nvidia.nix
      ./shell-environment.nix
      ./network.nix
      ./sound.nix
      ./gaming.nix
      # ./syncthing.nix
      ./docker.nix
      ./bluetooth.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # cachic for devenv - https://devenv.sh/guides/using-with-flakes/#modifying-your-flakenix-file
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;
  security.polkit.enable = true;

  # Automounting external drives
  services.gvfs.enable = true;
  services.udev.packages = [pkgs.libmtp.out];
  services.udisks2.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jcsan = {
    isNormalUser = true;
    description = "Jean Carlo San Juan";
    extraGroups = [ "networkmanager" "wheel" "adbuser" "docker" "input" ];
    packages = with pkgs; [

    ];
  };
  # Add this for xdg settings in home-manager to work
  # environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Note: ./de.nix adds more pkgs
  environment.systemPackages = with pkgs; [
    # My scripts
    libnotify
    reisen
    inputs.rofi-vscode-mode.packages.${system}.default
    rofi-network-manager
    niriswitcher
    # nerdfonts
    # bar
    vim
    wget
    vlc
    piper
    ## System utils
    p7zip
    jq
    socat
    ## Development
    ### Editors
    vscode.fhs # IMPORTANT!!!: I NEED FHS for VSCODE

    ### Version Control
    gh
    git

    ### Language Runtimes & Managers
    nixd
    nodejs_22
    pnpm-shim
    (python312.withPackages (ps: with ps; [
      torch
      jupyter
      notebook
      matplotlib
      scikit-learn
      pandas
      numpy
      memory-profiler
      xlrd # optional dep of pandas for xlsx
      img2pdf
      openai-whisper
    ]))
 
    espeak
    krita
    fastfetch
    # inkscape

    discord
    speechd
    nixpkgs-fmt
    google-chrome
    celluloid
    # caprine-bin

    qbittorrent
    ffmpeg-full
    yt-dlp

    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hyphen
    caprine
    # osu-lazer-bin # app image ver w/ online functionality
    # patchelfUnstable
    # mullvad-vpn
    # Niri stuff
    mako
    lenovo-legion
    linuxPackages_latest.lenovo-legion-module
    esbuild
    # latest kernel

    gnome-system-monitor
    nautilus
    cheese
    simple-scan
    gnome-text-editor
    gnome-clocks
    gnome-calendar
    gnome-online-accounts
    gnome-online-accounts-gtk
    gnome-decoder
    gnome-calculator
    gnome-sound-recorder
    gnome-control-center
    gnome-font-viewer
    networkmanagerapplet
    swww
    brightnessctl
    xwayland-satellite
    cliphist
    wl-clipboard
    xdg-utils

    aws-sam-cli
    awscli2
    qemu
    inputs.agsConf.packages.${system}.default
    lutris
    protonup-qt
    yarn
    # cuda packages needed by openai-whisper
    cudaPackages_12_8.cudatoolkit
    # cudaPackages_12_8.cudnn
  ];

  programs.firefox.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.printing.drivers = with pkgs; [ 
  #   epson_201207w
  #   gutenprint
  #   gutenprintBin 
  #   epson-escpr2
  #   epson-escpr
  # ];
  # For Piper to work
  services.ratbagd.enable = true;
  # programs.gamemode.enable = true;
  programs.adb.enable = true;
  # services.logind.extraConfig = ''
  #   # don't shutdown when power button is short-pressed
  #   HandlePowerKey=ignore
  # '';

  programs.niri = {
    enable = true;
  };

  programs.direnv.enable = true;
  nixpkgs.overlays = [

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
 
