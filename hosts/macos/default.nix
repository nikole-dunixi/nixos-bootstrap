# hosts/macos/default.nix
{ pkgs, ... }:
{
  imports = [
    ../../modules/darwin/base.nix
  ];

  networking.hostName = "macos";

  # nix-darwin requires this
  services.nix-daemon.enable = true;

  system.stateVersion = 5;
}