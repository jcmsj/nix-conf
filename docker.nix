{ ... }:
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      setSocketVariable = true;
      enable = true;
    };
  };
}
