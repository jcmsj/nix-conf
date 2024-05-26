# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, system, ... }:
let
  reisen = pkgs.callPackage ./reisen/reisen.nix { };
  my-firefox = pkgs.callPackage ./firefox.nix { };
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
      ./i18n.nix
      ./de.nix
      ./nvidia.nix
      ./shell-environment.nix
      ./network.nix
      ./sound.nix
      ./steam.nix
      ./syncthing.nix
    ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # Cachix for hyprland - https://wiki.hyprland.org/Nix/Cachix/
    # cachic for devenv - https://devenv.sh/guides/using-with-flakes/#modifying-your-flakenix-file
    substituters = [
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  nixpkgs.config = {
    allowUnfree = true;
    firefox.speechSynthesisSupport = true;
  };
  # start auth agen on login by creating a systemd user service: 

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
  # Add this for xdg settings in home-manager to work
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Note: ./de.nix adds more pkgs
  environment.systemPackages = with pkgs; [
    ## Required Apps
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # notif daemon
    mako
    libnotify
    # Wallpaper

    #Clipboards
    cliphist
    wl-clipboard
    wl-clip-persist

    # My scripts
    reisen
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
    playerctl
    vim
    wget
    vlc
    piper
    ## System utils

    ## Gaming
    glxinfo
    lshw
    steam-run
    #nvtop
    gamescope
    protonup-qt

    p7zip
    jq
    brightnessctl
    socat
    ## Development
    ### Editors
    vscode.fhs

    ### Version Control
    gh
    git

    ### Language Runtimes & Managers
    nil
    nodejs_22
    pnpm-shim
    php
    (python311.withPackages (ps: with ps; [
      jupyter
      notebook
      pandas
      xlrd # optional dep of pandas for xlsx
      scikit-learn
      matplotlib
      memory-profiler
      (buildPythonPackage {
        pname = "envycontrol";
        version = "3.4.0";
        src = fetchTarball {
          url = "https://github.com/bayasdev/envycontrol/archive/refs/tags/v3.4.0.tar.gz";
          sha256 = "sha256-m0ZH6kqLg15IfFtmoBqZgEe7wpIde/bIEyn6YY/L/xU=";
        };
        doCheck = false;
        propogatedBuildInputs = [

        ];
      })
    ]))
    inputs.fix-python.packages.${system}.default

    espeak
    krita
    fastfetch
    inkscape

    firefox
    my-firefox
    discord
    speechd
    nixpkgs-fmt
    google-chrome
    celluloid

    qbittorrent
    inputs.reisenScripts.packages.${system}.monitor
    inputs.reisenScripts.packages.${system}.restore
    inputs.reisenScripts.packages.${system}.nexus
    ffmpeg_7-headless
    yt-dlp

    libreoffice-fresh
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH

    osu-lazer
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.printing.drivers = with pkgs; [ 
  #   epson_201207w
  #   gutenprint
  #   gutenprintBin 
  #   epson-escpr2
  #   epson-escpr
  # ];
  services.upower.enable = true; # needed by ags
  # For Piper to work
  services.ratbagd.enable = true;
  programs.gamemode.enable = true;

  programs.adb.enable = true;
  services.logind.extraConfig = ''
    # don't shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  programs.direnv.enable = true;

  nixpkgs.overlays = [

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
 
