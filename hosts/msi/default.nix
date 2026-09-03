# hosts/msi/default.nix
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

      # Without offload/sync enabled, the NVIDIA GPU loads but nothing
      # ever renders on it — everything defaults to the Intel iGPU.
      offload = {
        enable = true;
        enableOffloadCmd = true; # `nvidia-offload <cmd>` for terminal use
      };
    };
  };

  # Lets GNOME's "Launch using Discrete Graphics Card" context menu
  # send desktop-entry apps (DaVinci Resolve, Blender, games, ...) to the dGPU.
  services.switcherooControl.enable = true;

  # Exposes the NVIDIA GPU to Docker containers (e.g. `docker run
  # --device=nvidia.com/gpu=all ollama/ollama`).
  hardware.nvidia-container-toolkit.enable = true;
}
