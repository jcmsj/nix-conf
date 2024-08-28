{
  exec-once = [
    "hyprlock"
    "ags"
    # Network manager
    "nm-applet --indicator"
    # Bluetooth
    "blueman-applet"
    "sleep 5 && blueman-tray"
    # Clipboards
    # "wl-paste --type text --watch cliphist store"
    # "wl-paste --type image --watch cliphist store"
    # Auto sleep
  ];
}
