#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$(basename "$(dirname "$0")")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}"
DESTINATION_DIR="${HOME}/.config"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "${TOOL}" "${TOOL}"

link_file \
  "${SOURCE_DIR}/${TOOL}.toml" \
  "${DESTINATION_DIR}/${TOOL}.toml"
