#!/usr/bin/env bash

set -eufCo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

install_brew_formula_if_missing "prettier" "prettier"
install_brew_formula_if_missing "npm" "node"

PRETTIER_PLUGINS=(
  "prettier-plugin-sql"
  "@prettier/plugin-xml"
  "prettier-plugin-tailwindcss"
)

npm install --global "${PRETTIER_PLUGINS[@]}"

link_file \
  "${SCRIPT_DIR}/.prettierrc" \
  "${HOME}/.prettierrc"
