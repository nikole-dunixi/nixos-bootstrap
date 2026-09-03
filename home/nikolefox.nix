{ pkgs, isWorkMachine ? false, isDevMachine ? false, isArtMachine ? false, ... }:
{
  imports = [ ../modules/home/base.nix ../modules/home/dev.nix ]
    ++ (if isWorkMachine then [ ../modules/home/work.nix ] else [])
    ++ (if isDevMachine then [ ../modules/home/dev.nix ] else [])
    ++ (if isArtMachine  then [ ../modules/home/art.nix  ] else []);

  home.username = "nikolefox";
  home.homeDirectory = "/home/nikolefox";
  home.stateVersion = "25.11";
}
