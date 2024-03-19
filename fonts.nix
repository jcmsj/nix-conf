{pkgs, ...}:
{
  # Handles systemwide fonts
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
        emoji = [ "noto-fonts-emoji" ];
      };
    };
  };
}
