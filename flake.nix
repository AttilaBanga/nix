{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nixos-wsl,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/darwin/darwin.nix
        ./common/packages.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.attilabanga = import ./common/home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
      specialArgs = {
        self = self;
      };
      system = "aarch64-darwin";
    };
    nixosConfigurations.azridum = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos/nixos/configuration.nix
        ./common/packages.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.azridum = import ./common/home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    nixosConfigurations.windows = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./common/packages.nix
        nixos-wsl.nixosModules.default
        {
          system.stateVersion = "24.05";
          wsl.enable = true;
          wsl.defaultUser = "nixos";
          wsl.useWindowsDriver = true;
          users.users.nixos = {
            shell = self.nixosConfigurations."windows".pkgs.zsh;
            extraGroups = ["docker"];
          };
          wsl.wslConf.boot.command = "tmux";
          wsl.startMenuLaunchers = true;
          virtualisation.docker = {
            enable = true;
            enableOnBoot = true;
          };
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = import ./common/home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mac".pkgs;
    nixosPackages = self.nixosConfigurations."windows".pkgs;
  };
}
