#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$(basename "$(dirname "$0")")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}"
DESTINATION_DIR="${HOME}/.config/${TOOL}"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

if is_macos; then
  install_brew_formula_if_missing "${TOOL}" "${TOOL}" "cask"
fi

link_file \
  "${SOURCE_DIR}/config" \
  "${DESTINATION_DIR}/config"
