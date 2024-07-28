{
  description = "Nixos flake configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq?rev=3f6d7a3e77732c1dbe4873b69404fefd899ad35e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    reisenScripts = {
      url = "github:jcmsj/hypr-conf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fix-python.url = "github:GuillaumeDesforges/fix-python";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rofi-vscode-mode = {
      url = "github:jcmsj/rofi-vscode-mode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use
  };
  outputs = inputs@{ self, nixpkgs, auto-cpufreq, home-manager, ags, aagl,... }:
    let
      username = "jcsan";
      system = "x86_64-linux";
      legacyPackages = nixpkgs.lib.genAttrs [ system ] (system:
        import inputs.nixpkgs {
          inherit system;
          # NOTE: Using `nixpkgs.config` in your NixOS config won't work
          # Instead, you should set nixpkgs configs here
          # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
          config = {
            allowUnfree = true;
            firefox.speechSynthesisSupport = true;
          };
        });
      pkgs = legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit pkgs;
            inherit inputs; # will let de.nix be able to use the hyprland flake.
          };
          modules = [
            ./configuration.nix
            auto-cpufreq.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.backupFileExtension = "backup";
              # Optionally, use home-manager.extraSpecialArgs to pass
              home-manager.extraSpecialArgs = { inherit inputs; };
              # arguments to home.nix
            }
            aagl.nixosModules.default
          ];
        };
      };
    };
}
