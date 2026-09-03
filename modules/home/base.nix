# modules/home/base.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    audacity
    brave
    kdePackages.kdenlive
    moonlight-qt
    telegram-desktop
    tree
    vscode
    yt-dlp
  ];

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;    # keeps nix shells from being garbage collected
  };
  # git
  programs.git = {
    enable = true;
      settings = {
        user.name  = "Nikole Dunixi";
        user.email = "1402178+nikole-dunixi@users.noreply.github.com";
        init.defaultBranch = "main";
        pull.ff = "only";
      };
  };
  # ssh
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        identityFile = "~/.ssh/id_ed25519";
      };
      "github.com" = {
        user = "nikole-dunixi";
      };
      "msi" = {
        user = "nikodunixi";
        hostname = "192.168.123.1";
      };
      "macos" = {
        user = "nikodunixi";
        hostname = "192.168.123.2";
      };
    };
  };
}
