{
  description = "Nixos flake configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let 
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit system; 
            inherit inputs; # will let de.nix be able to use the hyprland flake.
          };
          modules = [
            ./configuration.nix
          ];
        };
      };
  };
}
