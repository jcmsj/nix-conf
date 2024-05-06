{
  description = "Nixos flake configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    monitorSwitcher = {
      url = "github:jcmsj/hypr-conf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, auto-cpufreq, ... }:
    let
      username = "jcsan";
      system = "x86_64-linux";
      legacyPackages = nixpkgs.lib.genAttrs [ system ] (system:
        import inputs.nixpkgs {
          inherit system;
          # NOTE: Using `nixpkgs.config` in your NixOS config won't work
          # Instead, you should set nixpkgs configs here
          # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)

          config.allowUnfree = true;
          config.firefox.speechSynthesisSupport = true;
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
            # FIX: option `home` does not exist
            # ags.homeManagerModules.default  # another could be ags
            #  home-manager.nixosModules.home-manager
            # {
            #  home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.${username} = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            # }
          ];
        };
      };

      # FIX: service doesnt start
      # home-manager.useGlobalPkgs = true;
      # home-manager.useUserPackages = true;
      # homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #   # Specify your home configuration modules here, for example,

      #   # the path to your home.nix.
      #   modules = [
      #     ./home.nix
      #     ags.homeManagerModules.default  # another could be ags
      #     ];
      # };
    };
}
