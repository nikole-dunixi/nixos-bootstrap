#!/usr/bin/env bash
set -euo pipefail

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  NIX_SYSTEM="x86_64-linux" ;;
  aarch64) NIX_SYSTEM="aarch64-linux" ;;
  *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

STUB="/etc/nixos/flake.nix"

# Guard — don't clobber an existing flake
if [[ -f "$STUB" ]]; then
  echo "⚠️  $STUB already exists, skipping creation."
  echo "   Delete it manually if you want to regenerate."
  exit 0
fi

echo "→ Writing stub flake to $STUB (requires sudo)"

sudo tee "$STUB" > /dev/null << 'EOF'
{
  description = "System configuration";

  outputs = { self }: {
    nixosModules.system = ./configuration.nix;
  };
}
EOF

# sudo tee "$STUB" > /dev/null << EOF
# {
#   description = "System configuration";

#   inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

#   outputs = { self, nixpkgs }: {
#     nixosConfigurations.system = nixpkgs.lib.nixosSystem {
#       system = "${NIX_SYSTEM}";
#       modules = [ ./configuration.nix ];
#     };
#   };
# }
# EOF

echo "→ Staging stub flake for nix (git init if needed)"
if [[ ! -d /etc/nixos/.git ]]; then
  sudo git -C /etc/nixos init
fi
sudo git -C /etc/nixos add flake.nix

echo "✓ Done. You can now reference this from your personal flake:"
echo "    system-config.url = \"path:/etc/nixos\";"
