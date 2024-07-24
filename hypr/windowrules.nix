{
  "$cff" = "class:(firefox)";
  "$tpip" = "title:^(Firefox|Picture-in-Picture)$";
  "$titleOW" = "title:^(Overwatch)$";
  windowrulev2 = [
    # Picture-In-Picture mode Firefox
    "float, $cff, $tpip"
    "pin, $cff, $tpip"
    "move 67% 61.5%, $cff, $tpip"
    "size 33% 33%, $cff, $tpip"
    "noanim, $cff, $tpip"
    "keepaspectratio, $cff, $tpip"
    "bordersize 1, $cff, $tpip"
    "noshadow, $cff, $tpip"
    "nodim, $cff, $tpip"
    "noinitialfocus, $cff, $tpip"
    "bordercolor rgb(A0FFF9), $cff, $tpip"

    # OW
    "fullscreen, $titleOW"
    "workspace 9, $titleOW"
    "noanim, $titleOW"
    "monitor HDMI-A-1, $titleOW"

    # VLC
    "idleinhibit always,class:(vlc), title:^(VLC media player)$"
  ];
}
