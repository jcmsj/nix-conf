{ ... }:

{
  # Power management https://wiki.nixos.org/wiki/Laptop
  services.power-profiles-daemon.enable = false;
  
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  powerManagement.powertop.enable = true;
}
