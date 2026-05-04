# hosts/laptop/default.nix
{ config, pkgs, ... }:
{
  imports = [
    ../../modules/system/base.nix
  ];

  # networking.hostName = "msi";

  # NVIDIA hybrid graphics (Intel + NVIDIA prime)
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    prime = {
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
