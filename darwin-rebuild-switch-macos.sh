#!/usr/bin/env bash
set -euxo pipefail
./bootstrap-system-flake.sh
./ssh-keygen.sh
darwin-rebuild switch --flake .#macos
