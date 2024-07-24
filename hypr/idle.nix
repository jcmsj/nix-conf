{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "notify-send \"lock!\"";
        unlock_cmd = "notify-send \"unlock!\""; # same as above, but unlock
        before_sleep_cmd = "hyprlock"; # command ran before sleep
        after_sleep_cmd = "notify-send \"Awake!\""; # command ran after sleep
        ignore_dbus_inhibit = true;
      };

      listener = [
        {
          timeout = 300; # 5mins
          # lock screen when timeout has passed
          on-timeout = "hyprctl dispatch dpms off"; # turn off displays
          # on-resume = notify-send "Welcome back!"
        }
        {
          timeout = 600; # 10min
          # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate
          on-timeout = "systemctl suspend"; # suspend/sleep pc
          # on-timeout = systemctl hibernate # suspend pc
          # on-resume = notify-send "Welcome back!"
        }
      ];
    };
  };
}
