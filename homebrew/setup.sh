#!/usr/bin/env bash

set -eufCo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

if [ "${WORK_SETUP:-0}" != "1" ]; then
  export HOMEBREW_BUNDLE_BREW_SKIP="asdf protoc-gen-go-grpc protoc-gen-go protoc-gen-js tailscale"
  export HOMEBREW_BUNDLE_CASK_SKIP="1password-cli 1password dbeaver-community postman slack"
fi

bash "${SCRIPT_DIR}/../bashrc/setup.sh"

if [ ! -L "${HOME}/Brewfile" ] || [ "$(readlink "${HOME}/Brewfile" 2>/dev/null)" != "${SCRIPT_DIR}/Brewfile" ]; then
  if [ -e "${HOME}/Brewfile" ] || [ -L "${HOME}/Brewfile" ]; then
    read -r -p "Replace ${HOME}/Brewfile? Existing file will be moved to ${HOME}/Brewfile.bak (y/n): " answer
    if [[ "${answer}" =~ ^[Yy]$ ]]; then
      rm -rf "${HOME}/Brewfile.bak"
      mv "${HOME}/Brewfile" "${HOME}/Brewfile.bak"
      ln -sfn "${SCRIPT_DIR}/Brewfile" "${HOME}/Brewfile"
    fi
  else
    ln -s "${SCRIPT_DIR}/Brewfile" "${HOME}/Brewfile"
  fi
fi

brew bundle --file "${SCRIPT_DIR}/Brewfile"

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
