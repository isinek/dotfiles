#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$( basename "$(dirname "$0")" )"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "${TOOL}" "${TOOL}"

link_file_with_backup \
  "${SCRIPT_DIR}/.config/tmux/tmux.conf" \
  "${HOME}/.config/tmux/tmux.conf"

ensure_directory "${HOME}/.config/tmux/plugins"

if [ ! -d "${HOME}/.config/tmux/plugins/tpm/.git" ]; then
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.config/tmux/plugins/tpm"
else
  echo "already installed: ${HOME}/.config/tmux/plugins/tpm"
fi

if [ -n "${TMUX:-}" ] || tmux list-sessions >/dev/null 2>&1; then
  tmux source-file "${HOME}/.config/tmux/tmux.conf"
fi
