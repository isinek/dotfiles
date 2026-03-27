#!/usr/bin/env bash

set -eufCo pipefail

TOOL="$( basename "$(dirname "$0")" )"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

if ! is_macos; then
  echo "Skipping ${TOOL}: supported only on macOS."
  exit 0
fi

install_brew_cask_if_missing "${TOOL}" "${TOOL}"

link_file_with_backup \
  "${SCRIPT_DIR}/.aerospace.toml" \
  "${HOME}/.aerospace.toml"
