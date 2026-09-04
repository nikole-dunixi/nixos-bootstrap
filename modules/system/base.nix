# modules/system/base.nix
{ config, pkgs, lib, ... }:
{
  # Set the experimental-features globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Sunshine — game streaming protocol, used as primary remote desktop across all machines
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # SSH — disable password auth
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Audio — use pipewire instead of pulseaudio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- sops: secrets decrypted into /run/secrets at boot (age key) ---
  sops.age.keyFile = "/home/nikolefox/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../secrets/ollama.yaml;
  # Disable neededForUsers so this is a "regular" secret. sops-nix only renders
  # templates (/run/secrets/*) when there is at least one regular (non
  # neededForUsers) secret; with the token marked neededForUsers the templates
  # (ollama-env and ollama-token-user) were never created.
  sops.useSystemdActivation = true;
  sops.secrets."ollama-token" = {
    key = "OLLAMA_AUTH_TOKEN";
    owner = "root";
    group = "users";
    mode = "0440";
  };

  # --- Ollama: local LLM server, accelerated with the NVIDIA GPU (CUDA build) ---
  # The daemon is declared but NOT started on boot so it doesn't reserve GPU
  # memory until you need it. Start/stop it on demand with:
  #   systemctl start ollama    # turn on
  #   systemctl stop ollama     # turn off
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    user = "ollama";
    group = "ollama";
    host = "127.0.0.1"; # bind to loopback only; not exposed to the LAN
  };
  # Load the decrypted API token from the sops-rendered environment file into
  # the ollama service. Any client must send `Authorization: Bearer <token>`.
  systemd.services.ollama.serviceConfig.EnvironmentFile = [
    config.sops.templates."ollama-env".path
  ];
  sops.templates."ollama-env" = {
    content = "OLLAMA_AUTH_TOKEN=${config.sops.placeholder."ollama-token"}";
    owner = "ollama";
    group = "users";
    mode = "0440";
  };
  # Prevent auto-start on boot so the GPU isn't reserved until you need it.
  systemd.services.ollama.wantedBy = lib.mkForce [ ];
}
