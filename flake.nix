{
  description = "Nixos flake configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rofi-vscode-mode = {
      url = "github:jcmsj/rofi-vscode-mode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    # aagl.inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agsConf = {
      url = "github:jcmsj/ags-conf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # auto-cpufreq = {
    #   url = "github:AdnanHodzic/auto-cpufreq";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
  outputs = inputs@{ self, nixpkgs, home-manager,agsConf, lanzaboote, ... }:
    let
      username = "jcsan";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { 
          allowUnfree = true; 
          firefox.speechSynthesisSupport = true;
          chromium.enableWideVine = true;
          cudaSupport = true;
        };
      };

      # pkgs = legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit pkgs;
            inherit inputs; # will let de.nix be able to use the hyprland flake.
            inherit system;
          };
          modules = [
            ./configuration.nix
            {
              # given the users in this list the right to specify additional substituters via:
              #    1. `nixConfig.substituters` in `flake.nix`
              nix.settings.trusted-users = [ "jcsan" ];
              nix.settings.download-buffer-size = 524288000; # 500 MiB
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.backupFileExtension = "backup";
              # Optionally, use home-manager.extraSpecialArgs to pass
              home-manager.extraSpecialArgs = { inherit inputs; inherit system; };
              # arguments to home.nix
            }
            # aagl.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
              # auto-cpufreq.nixosModules.default
          ];
        };
      };
    };
}
