{pkgs, ...}:
{
  # Handles systemwide fonts
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      iosevka-bin
      source-serif-pro
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Iosevka" ];
        monospace = [ "Iosevka" ];
        serif = [ "Source Serif Pro" "Ioesevka" ];
        emoji = [ "noto-fonts-emoji" ];
      };
    };
  };
}
