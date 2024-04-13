{ ... }:

{
  # Power management https://wiki.nixos.org/wiki/Laptop
  services.power-profiles-daemon.enable = false;

  programs.auto-cpufreq.enable = true;
  programs.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };

    battery = {
      governor = "powersave";
      turbo = "never";
    };
  };
}
