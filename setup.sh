#!/usr/bin/env bash

set -eufCo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

function usage() {
  echo "usage: ${SCRIPT_DIR}/setup.sh [-w] <tool [tool [...]]>"
  echo "options:"
  echo "  -w    enable work-only setup targets"
  echo "tools:"
  while IFS= read -r tool_path; do
    echo "  ${tool_path}"
  done < <(
    find "${SCRIPT_DIR}" -mindepth 1 -maxdepth 1 -type d \
      ! -name '.git' \
      ! -name 'lib' \
      -exec basename {} \; | sort
  )
}

function fail() {
  echo "$*" >&2
  exit 1
}

function run_setup() {
  local tool=$1
  local script_path="${SCRIPT_DIR}/${tool}/setup.sh"

  if [ ! -d "${SCRIPT_DIR}/${tool}" ]; then
    echo "missing setup for '${tool}'" >&2
    return 1
  fi

  if [ ! -x "${script_path}" ]; then
    fail "setup script is not executable: ${script_path}"
  fi

  echo "setup ${tool}"
  "${script_path}"
}

WORK_SETUP=0

while getopts "hw" opt; do
  case ${opt} in
  h)
    usage
    exit 0
    ;;
  w)
    WORK_SETUP=1
    ;;
  *)
    usage
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

TOOLS=("$@")
export WORK_SETUP

for tool in "${TOOLS[@]}"; do
  run_setup "${tool}"
done
