{
  services.hyprpaper = {
    enable = true;
    settings = 
    let
      theme = import ./theme.nix { };
      wallpaper = "${theme.wallpaper.default}";
    in
    {
      preload = [
        wallpaper
      ];

      wallpaper = [
        "eDP-1,${wallpaper}"
        "HDMI-A-1,${wallpaper}"
      ];
    };
  };
}
