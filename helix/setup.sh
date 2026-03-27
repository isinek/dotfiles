#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$( basename "$(dirname "$0")" )"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "hx" "${TOOL}"

link_file_with_backup \
  "${SCRIPT_DIR}/.config/${TOOL}/config.toml" \
  "${HOME}/.config/${TOOL}/config.toml"

link_file_with_backup \
  "${SCRIPT_DIR}/.config/${TOOL}/languages.toml" \
  "${HOME}/.config/${TOOL}/languages.toml"
