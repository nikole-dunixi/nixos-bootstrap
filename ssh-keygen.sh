#!/usr/bin/env bash
set -euxo pipefail
[ -f ~/.ssh/id_ed25519 ] || {
  ssh-keygen -t ed25519 -C '1402178+nikole-dunixi@users.noreply.github.com'
}
