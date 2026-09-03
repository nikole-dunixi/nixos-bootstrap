# modules/system/base.nix
{ ... }:
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
    passwordAuthentication = false;
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
}
