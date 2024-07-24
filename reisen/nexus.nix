{ lib, pkgs, inputs, ... }:
{
  # A nixos module that installs the nexus package
  environment.systemPackages =
    let
      grimblast = inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;
      nexus = pkgs.writeShellScriptBin "nexus" (builtins.readFile ./nexus.sh);
    in
    with pkgs; [
      grimblast
      slurp
      swappy
      nexus
    ];
}
