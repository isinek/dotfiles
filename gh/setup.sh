#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$( basename "$(dirname "$0")" )"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "${TOOL}" "${TOOL}"

link_file_with_backup \
  "${SCRIPT_DIR}/.config/${TOOL}/config.yml" \
  "${HOME}/.config/${TOOL}/config.yml"

link_file_with_backup \
  "${SCRIPT_DIR}/.config/${TOOL}/hosts.yml" \
  "${HOME}/.config/${TOOL}/hosts.yml"
