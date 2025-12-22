{pkgs, ...}:
{
  # Handles systemwide fonts
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      iosevka-bin
      source-serif-pro
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
      font-awesome
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Iosevka" ];
        monospace = [ "Iosevka" ];
        serif = [ "Source Serif Pro" "Ioesevka" ];
        emoji = [ "noto-fonts-color-emoji" ];
      };
    };
  };
}
