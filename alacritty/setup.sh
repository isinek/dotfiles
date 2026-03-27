#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$( basename "$(dirname "$0")" )"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

if is_macos; then
  install_brew_cask_if_missing "${TOOL}" "${TOOL}"
else
  install_brew_formula_if_missing "${TOOL}" "${TOOL}"
fi

link_file_with_backup \
  "${SCRIPT_DIR}/.config/${TOOL}/alacritty.toml" \
  "${HOME}/.config/${TOOL}/alacritty.toml"
