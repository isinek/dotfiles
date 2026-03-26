#!/bin/bash

set -eufCo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Install homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
fi

pushd ~/ &> /dev/null
for file in "${SCRIPT_DIR}/Brewfile"; do
  conf_file="$( basename "${file}" )"
  if [[ -e "${conf_file}" || -L "${conf_file}" ]]; then
    read -p "File already exists. Make a backup and replace it? (y/n): " answer
    if [[ "${answer}" =~ ^[Yy] ]]; then
      mv "${conf_file}" "${conf_file}.bak"
      ln -s "${file}"
    fi
  else
    ln -s "${file}"
  fi
done
brew bundle

if command -v dotnet >/dev/null 2>&1; then
  dotnet tool update --global csharp-ls || dotnet tool install --global csharp-ls
fi
popd &> /dev/null
