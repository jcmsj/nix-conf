let
  mod = "SUPER";
  modshift = "${mod} SHIFT";
  modctrl = "${mod} CTRL";
  bind = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
  bindm = mod: cmd: key : "${mod}, ${key}, ${cmd}";
  mvfocus = {key, dir}: bind "SUPER" "movefocus" key dir;
  bmod = bind mod;
  bnone = bind "";
  exec = "exec";
  workspace = bmod "workspace";
  mvtows = bind modshift "movetoworkspace";
  movewindow = "movewindow";
in
{
  "$mod" = "SUPER";
  bind = [
    # App binds
    (bmod exec "C" "kitty")
    (bmod "killactive" "Q" "")
    (bmod exec "E" "nautilus")
    (bmod "exit" "M" "")

    # Layout
    (bmod "togglefloating" "V" "")
    (bmod "pseudo" "P" "") # dwindle
    (bmod "togglesplit" "J"  "") # dwindle
    (bind modshift "togglegroup" "T" "") # grouped tabbed mode

    # Move focus with mainMod + arrow keys
    (mvfocus {key="left"; dir="l";})
    (mvfocus {key="right"; dir="r";})
    (mvfocus {key="up"; dir="u";})
    (mvfocus {key="down"; dir="d";})
    # Remove from group
    (bind modshift "moveoutofgroup" "W" "")

    # Switch workspaces with mainMod + [0-9]
    (workspace "1" "1")
    (workspace "2" "2")
    (workspace "3" "3")
    (workspace "4" "4")
    (workspace "5" "5")
    (workspace "6" "6")
    (workspace "7" "7")
    (workspace "8" "8")
    (workspace "9" "9")

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    (mvtows "1" "1")
    (mvtows "2" "2")
    (mvtows "3" "3")
    (mvtows "4" "4")
    (mvtows "5" "5")
    (mvtows "6" "6")
    (mvtows "7" "7")
    (mvtows "8" "8")
    (mvtows "9" "9")

    # Scroll through existing workspaces with mainMod + scroll
    (workspace "mouse_down" "e+1")
    (workspace "mouse_up" "e-1")

    # altab
    (bind "ALT" "cyclenext" "Tab" "")
    (bind "ALT" "bringactivetotop" "Tab" "")
    (bind "ALT" "changegroupactive" "TAB" "") # when tabbed mode

    # Handle power button
    # TODO

    # Rofi launcher
    (bmod exec "S" "rofi -show drun -show-icons")
    ## Firefox profile switcher
    (bmod exec "U" "rofi -show \"Profile Switcher\" -modi \"Profile Switcher:~/.config/rofi/scripts/rofi-ffp.sh\"")
    (bmod exec "O" "rofi -show \"VSCode\" -modi \"VSCode:~/.config/rofi/scripts/rofi-vscode.sh\"")

    # move window to another monitor
    ## Using H, J, K, L
    (bind modshift movewindow "H" "l")
    (bind modshift movewindow "J" "d")
    (bind modshift movewindow "K" "u")
    (bind modshift movewindow "L" "r")
    ## Using arrow keys
    (bind modctrl movewindow "left" "l")
    (bind modctrl movewindow "down" "d")
    (bind modctrl movewindow "up" "u")
    (bind modctrl movewindow "right" "r")

    # AGS
    ## For development
    (bind modctrl exec "A" "ags -q")
    (bind modctrl exec "A" "sleep 1 && ags")

    ## Power menu
    (bind "CTRL+ALT" exec "Delete" "ags -r togglePowerMenu()")
    (bind "ALT" exec "F4" "ags -r togglePowerMenu()")

    # Task manager
    (bind "CTRL+SHIFT" exec "Escape" "ags -r toggleTaskManager()")

    (bnone exec "PRINT" "nexus area")
    (bind "CTRL" exec "PRINT" "nexus active")

    # Hyprexpo
    (bmod "hyprexpo:expo" "TAB" "toggle")
  ];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    (bindm mod "movewindow" "mouse:272")
    (bindm mod "resizewindow" "mouse:273")
  ];

  binde = [
    # Example volume button that allows press and hold, volume limited to 150%
    (bnone "exec" "XF86AudioRaiseVolume" "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+")
    # Example volume button that will activate even while an input inhibitor is active
    (bnone "exec" "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-")

    # brightness
    (bnone "exec" "XF86MonBrightnessDown" "brightnessctl set 3%-")
    (bnone "exec" "XF86MonBrightnessUp" "brightnessctl set +3%")
  ];

  env = [
    "SLURP_ARGS, -d -b -B F050F022 -b 10101022 -c ff00ff"
    "GRIMBLAST_EDITOR, swappy"
  ];
}
