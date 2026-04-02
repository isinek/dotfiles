#!/usr/bin/env bash

set -eufCo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE_HOME="${SCRIPT_DIR}/Brewfile.home"
BREWFILE_WORK="${SCRIPT_DIR}/Brewfile.work"
TARGET_BREWFILE="${HOME}/Brewfile"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

if ! command -v brew >/dev/null 2>&1; then
  echo "Install homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

bash "${SCRIPT_DIR}/../bashrc/setup.sh"

tmp_brewfile="$(mktemp "${HOME}/Brewfile.XXXXXX")"
trap 'rm -f "${tmp_brewfile}"' EXIT

cat "${BREWFILE_HOME}" >>"${tmp_brewfile}"
if [ "${WORK_SETUP:-0}" = "1" ]; then
  echo >>"${tmp_brewfile}"
  cat "${BREWFILE_WORK}" >>"${tmp_brewfile}"
fi

if ! cmp -s "${tmp_brewfile}" "${TARGET_BREWFILE}"; then
  if ! prompt_backup "${TARGET_BREWFILE}"; then
    echo "backup skipped: ${TARGET_BREWFILE}"
  else
    rm -rf "${TARGET_BREWFILE}.bak"
    mv "${TARGET_BREWFILE}" "${TARGET_BREWFILE}.bak"
  fi

  mv "${tmp_brewfile}" "${TARGET_BREWFILE}"
fi

brew bundle --file "${TARGET_BREWFILE}"

if command -v dotnet >/dev/null 2>&1; then
  if [ -x "/opt/homebrew/opt/dotnet/libexec/dotnet" ]; then
    export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
  elif [ -x "/usr/local/share/dotnet/dotnet" ]; then
    export DOTNET_ROOT="/usr/local/share/dotnet"
  elif [ -x "${HOME}/.dotnet/dotnet" ]; then
    export DOTNET_ROOT="${HOME}/.dotnet"
  fi

  dotnet tool update --global csharp-ls || dotnet tool install --global csharp-ls
fi
