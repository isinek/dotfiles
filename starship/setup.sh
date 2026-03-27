#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$( basename "$(dirname "$0")" )"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "${TOOL}" "${TOOL}"

link_file_with_backup \
  "${SCRIPT_DIR}/.config/${TOOL}.toml" \
  "${HOME}/.config/${TOOL}.toml"
