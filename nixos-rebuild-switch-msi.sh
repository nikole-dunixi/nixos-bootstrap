#!/usr/bin/env bash
set -euxo pipefail
./bootstrap-system-flake.sh
./ssh-keygen.sh
nixos-rebuild switch --sudo --flake .#msi
