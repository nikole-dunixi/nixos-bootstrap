{
  description = "Nikole Fox's NixOS configuratoin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    system-config.url = "path:/etc/nixos";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, system-config, home-manager, ... }:
  let
    system = "x86_64-linux";
    specialArgs = {
      isWorkMachine = false;
      isArtMachine  = true;
    };
  in {
    nixosConfigurations = {
      msi = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          system-config.nixosModules.system
          ./hosts/msi/default.nix
          # ./modules/system/base.nix
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
    };
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
