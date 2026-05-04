{
  description = "Nikole Fox's NixOS configuratoin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    system-config.url = "path:/etc/nixos";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, system-config, home-manager, nix-darwin, ... }:
  let
    linuxSystem = "x86_64-linux";
    macSystem   = "aarch64-darwin";
  in {
    nixosConfigurations = {
      msi = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [
          system-config.nixosModules.system
          ./hosts/msi/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              isWorkMachine = false;
              isArtMachine  = true;
            };
            home-manager.users.nikolefox = import ./home/nikolefox.nix;
          }
        ];
      };
      darwinConfigurations.macos = nix-darwin.lib.darwinSystem {
        system = macSystem;
        modules = [
          ./hosts/macos/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              isWorkMachine = true;
              isArtMachine  = false;
            };
            home-manager.users.nikolefox = import ./home/nikolefox.nix;
          }
        ];
      };
    };
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
