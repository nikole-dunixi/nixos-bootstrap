# modules/home/dev.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    claude-code
    ffmpeg
    gnumake
    jq
    nodejs
    opencode
    ripgrep
  ];
  # Local-only opencode: force the local ollama provider and ignore every
  # hosted/built-in remote provider (e.g. the `opencode` hosted models). The
  # default model resolves to the locally-installed qwen2.5-coder:7b tag.
  programs.opencode = {
    enable = true;
    settings = {
      enabled_providers = [ "ollama" ];
      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options = {
          baseURL = "http://localhost:11434/v1";
          apiKey = "{env:OLLAMA_API_KEY}";
        };
        models = {
          "qwen2.5-coder:0.5b" = {
          };
          "qwen2.5-coder:7b" = {
          };
        };
      };
      model = "ollama/qwen2.5-coder:7b";
      share = "disabled";
    };
  };
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
