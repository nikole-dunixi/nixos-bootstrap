#!/usr/bin/env bash
set -euxo pipefail
./bootstrap-system-flake.sh
./ssh-keygen.sh
nix flake update system-config
nixos-rebuild switch --sudo --flake .#msi
