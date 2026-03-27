#!/usr/bin/env bash

set -eufCo pipefail

function os_name () {
  uname -s
}

function is_macos () {
  [ "$(os_name)" = "Darwin" ]
}

function is_linux () {
  [ "$(os_name)" = "Linux" ]
}

function command_exists () {
  command -v "$1" >/dev/null 2>&1
}

function ensure_directory () {
  mkdir -p "$1"
}

function repo_root () {
  local lib_dir

  lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  cd "${lib_dir}/.." && pwd -P
}

function assert_target_path_outside_repo () {
  local target_path=$1
  local root

  root="$(repo_root)"

  case "${target_path}" in
    "${root}"|"${root}"/*)
      echo "refusing to write into repo from setup script: ${target_path}" >&2
      exit 1
      ;;
  esac
}

function prompt_replace () {
  local target=$1
  local answer

  read -r -p "Replace ${target}? Existing file will be moved to ${target}.bak (y/n): " answer
  [[ "${answer}" =~ ^[Yy]$ ]]
}

function link_file_with_backup () {
  local source_path=$1
  local target_path=$2
  local target_dir

  assert_target_path_outside_repo "${target_path}"
  target_dir="$(dirname "${target_path}")"
  ensure_directory "${target_dir}"

  if [ -L "${target_path}" ] && [ "$(readlink "${target_path}")" = "${source_path}" ]; then
    echo "already linked: ${target_path}"
    return 0
  fi

  if [ -e "${target_path}" ] || [ -L "${target_path}" ]; then
    if ! prompt_replace "${target_path}"; then
      echo "skipped: ${target_path}"
      return 0
    fi

    rm -rf "${target_path}.bak"
    mv "${target_path}" "${target_path}.bak"
  fi

  ln -sfn "${source_path}" "${target_path}"
  echo "linked ${target_path} -> ${source_path}"
}

function install_brew_formula_if_missing () {
  local command_name=$1
  local formula_name=$2

  if command_exists "${command_name}"; then
    return 0
  fi

  if ! command_exists brew; then
    echo "Install ${formula_name} manually"
    exit 1
  fi

  echo "Installing ${formula_name} using brew..."
  brew install "${formula_name}"
}

function install_brew_cask_if_missing () {
  local command_name=$1
  local cask_name=$2

  if command_exists "${command_name}"; then
    return 0
  fi

  if ! is_macos; then
    echo "Skipping ${cask_name}: Homebrew casks are only supported on macOS."
    return 0
  fi

  if ! command_exists brew; then
    echo "Install ${cask_name} manually"
    exit 1
  fi

  echo "Installing ${cask_name} using brew..."
  brew install --cask "${cask_name}"
}
