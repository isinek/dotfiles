#!/usr/bin/env bash

set -eufCo pipefail

function os_name() {
  uname -s
}

function is_macos() {
  [ "$(os_name)" = "Darwin" ]
}

function is_linux() {
  [ "$(os_name)" = "Linux" ]
}

function command_exists() {
  command -v "$1" >/dev/null 2>&1
}

function ensure_directory() {
  mkdir -p "$1"
}

function repo_root() {
  local lib_dir

  lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  cd "${lib_dir}/.." && pwd -P
}

function assert_target_path_outside_repo() {
  local target_path=$1
  local root

  root="$(repo_root)"

  case "${target_path}" in
  "${root}" | "${root}"/*)
    echo "refusing to write into repo from setup script: ${target_path}" >&2
    exit 1
    ;;
  esac
}

function prompt_backup() {
  local target=$1
  local answer

  read -r -p "${target} will be replaced! Do you want to move file to ${target}.bak? (y/n/q): " answer
  if [[ "${answer}" =~ ^[Qq]$ ]]; then
    echo "cancelled"
    exit 0
  fi

  [[ "${answer}" =~ ^[Yy]$ ]]
}

function link_file() {
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
    if ! prompt_backup "${target_path}"; then
      echo "backup skipped: ${target_path}"
    else
      rm -rf "${target_path}.bak"
      mv "${target_path}" "${target_path}.bak"
    fi
  fi

  ln -sfn "${source_path}" "${target_path}"
  echo "linked ${target_path} -> ${source_path}"
}

function install_brew_formula_if_missing() {
  local command_name=$1
  local formula_name=$2
  local cask=
  local package_name="${formula_name}"

  if [ $# -gt 2 ]; then
    cask=1
  fi

  if command_exists "${command_name}"; then
    return 0
  fi

  if ! command_exists brew; then
    echo "Install ${formula_name} manually"
    exit 1
  fi

  if [ -n "${cask}" ]; then
    if ! is_macos; then
      echo "Skipping ${package_name}: Homebrew casks are only supported on macOS."
      return 0
    fi

    echo "Installing ${package_name} using brew..."
    brew install --cask "${package_name}"
  else
    echo "Installing ${package_name} using brew..."
    brew install "${package_name}"
  fi
}
