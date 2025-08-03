{pkgs,...}:
{
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "jcsan" ];
  environment.systemPackages = with pkgs; [
    razergenie
  ];
}
