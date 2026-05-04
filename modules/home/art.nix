# modules/home/art.nix
{ pkgs, ... }:
{
  home.packages = [
    pkgs.blender
    pkgs.davinci-resolve
    pkgs.krita
  ];
}