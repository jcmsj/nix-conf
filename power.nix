{ pkgs, ... }:

{
  # Power management https://wiki.nixos.org/wiki/Laptop
  powerManagement.enable = true;
  # powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = false;

  # services.logind.lidSwitch = "poweroff";
  # services.logind.lidSwitchExternalPower = "lock";
  # services.logind.lidSwitchDocked = "ignore";

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;

  #     #Optional helps save long term battery health
  #     # START_CHARGE_THRESH_BAT0 = 30; # 30 and bellow it starts to charge
  #     # STOP_CHARGE_THRESH_BAT0 = 85; # 85 and above it stops charging

  #   };
  # };
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
      #  START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
};

  # programs.auto-cpufreq.enable = true;

  # optionally, you can configure your auto-cpufreq settings, if you have any
  # programs.auto-cpufreq.settings = {
    # charger = {
      # governor = "performance";
      # turbo = "auto";
    # };
    # battery = {
      # governor = "power";
      # turbo = "auto";
      # ideapad_laptop_conservation_mode = true;
    # };
  # };
  # services.undervolt = {
  #   enable = true;
  #   coreOffset = -30;
  #   gpuOffset = -10;
  #   uncoreOffset = -10;
  #   tempAc = 90;
  #   tempBat = 80;
  # };

  services.upower.enable = true; # needed by ags
  environment.systemPackages = with pkgs; [
    powertop
    # undervolt
    htop
  ];
}
