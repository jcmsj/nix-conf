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
      # ./gaming.nix
      # ./syncthing.nix
      ./docker.nix
      # ./bluetooth.nix
    ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # Cachix for hyprland - https://wiki.hyprland.org/Nix/Cachix/
    # cachic for devenv - https://devenv.sh/guides/using-with-flakes/#modifying-your-flakenix-file
    substituters = [
      # "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      # "https://ezkea.cachix.org"
      # "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      # "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      # "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Gnome
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Automounting external drives
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jcsan = {
    isNormalUser = true;
    description = "Jean Carlo San Juan";
    extraGroups = [ "networkmanager" "wheel" "adbuser" "docker" ];
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
    # App launcher
    # inputs.rofi-vscode-mode.packages.${system}.default
    # networkmanagerapplet
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
    nodejs_23
    pnpm-shim
    (python311.withPackages (ps: with ps; [
      jupyter
      notebook
      matplotlib
      scikit-learn
      pandas
      numpy
      memory-profiler
      xlrd # optional dep of pandas for xlsx
    ]))
    
    espeak
    krita
    fastfetch
    # inkscape

    discord
    speechd
    nixpkgs-fmt
    # google-chrome
    celluloid
    # caprine-bin

    # qbittorrent
    ffmpeg-full
    yt-dlp

    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hyphen

    # osu-lazer-bin # app image ver w/ online functionality
    # patchelfUnstable
    # mullvad-vpn
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

  programs.direnv.enable = true;
  nixpkgs.overlays = [

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
 
