#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$(basename "$(dirname "$0")")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}"
DESTINATION_DIR="${HOME}/.config/${TOOL}"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "${TOOL}" "${TOOL}"

link_file \
  "${SOURCE_DIR}/tmux.conf" \
  "${DESTINATION_DIR}/tmux.conf"

ensure_directory "${DESTINATION_DIR}/plugins"

if [ ! -d "${DESTINATION_DIR}/plugins/tpm/.git" ]; then
  git clone https://github.com/tmux-plugins/tpm "${DESTINATION_DIR}/plugins/tpm"
else
  echo "already installed: ${DESTINATION_DIR}/plugins/tpm"
fi

if [ -n "${TMUX:-}" ] || tmux list-sessions >/dev/null 2>&1; then
  tmux source-file "${DESTINATION_DIR}/tmux.conf"
fi
