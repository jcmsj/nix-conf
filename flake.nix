{
  description = "Nixos flake configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # add ags
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ags, ... }:
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
          ags.homeManagerModules.default  # another could be ags
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jcsan = import ./home.nix {inherit inputs;};
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          ];
        };
      };
  };
}
