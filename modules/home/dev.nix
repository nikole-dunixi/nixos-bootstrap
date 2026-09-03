# modules/home/dev.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    gnumake
    nodejs
    opencode
  ];
  programs.ghostty = {
    enable = true;
    # Enable shell integration for your shell (bash, zsh, fish)
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

     # Declarative configuration options
    settings = {
    #   font-family = "JetBrains Mono";
    #   font-size = 14;
      background-opacity = 0.9;
    #   # window-decoration = false;
    #   # theme = "dark:zenwritten_dark";
    };
  };
}
