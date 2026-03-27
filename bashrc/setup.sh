#!/usr/bin/env bash

set -eufCo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/setup.sh"

if grep -Eq '^[[:space:]]*\[ -r ~/.bashrc\.user \] && \. ~/.bashrc\.user[[:space:]]*$' "${HOME}/.bashrc"; then
  echo "${HOME}/.bashrc already sources ~/.bashrc.user, skipping bashrc setup"
  exit 0
fi

if ! grep -q ".bashrc.user" "${HOME}/.bashrc"; then
  echo >> ~/.bashrc
  echo "[ -r ~/.bashrc.user ] && . ~/.bashrc.user" >> ~/.bashrc
fi

link_file_with_backup "${SCRIPT_DIR}/.bashrc.user" "${HOME}/.bashrc.user"
link_file_with_backup "${SCRIPT_DIR}/.bash_aliases" "${HOME}/.bash_aliases"

if [ "${WORK_SETUP:-0}" = "1" ]; then
  link_file_with_backup "${SCRIPT_DIR}/.bashrc.work" "${HOME}/.bashrc.work"
fi
