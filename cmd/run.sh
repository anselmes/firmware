#!/bin/bash

# Copyright (c) 2023 Schubert Anselme <schubert@anselm.es>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

set -e

export OVERWRITE=false
export WORKSPACE="/workspace"

export COPY_CMD="${WORKSPACE}/scripts/copy.sh"

export UBOOT_PATH="${WORKSPACE}/modules/u-boot"
export COREBOOT_PATH="${WORKSPACE}/modules/coreboot"
export OPENSBI_PATH="${WORKSPACE}/modules/opensbi"

NBPROC="$(nproc)"
export NBPROC

# notice
print_notice()
{
  echo """
Copyright (C) 2023  Schubert Anselme <schubert@anselm.es>
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions.
  """
}

# help
print_help()
{
  echo """
Usage: ./cmd/run.sh [OPTIONS] COMMAND [ARGS]...

Options:
  -h, --help            Show this message and exit.
  -v, --version         Show version and exit.
  -r, --repo            Set repository.
  -p, --prefix          Set compiler prefix.
  --overwrite           Overwrite existing files.

Commands:
  deps                  Install dependencies.
  coreboot              Build coreboot.
  opensbi               Build opensbi.
  uboot                 Build uboot.
  onie                  Build onie.
  clean <target>        Clean target.

Examples:
  ./cmd/run.sh deps
  """
  exit 0
}

# version
print_version()
{
  echo "Version: 0.0.1"
  exit 0
}

# clean
clean()
{
  TARGET="${1}"
  [[ -n "${TARGET}" ]] && echo """
TARGET: ${TARGET}

cleaning ${TARGET}...
  """

  case "${TARGET}" in
    coreboot)
      cd "${COREBOOT_PATH}" \
        && CROSS_COMPILE="${CROSS_COMPILE}" make distclean -j "${NBPROC}"
      ;;
    opensbi)
      cd "${OPENSBI_PATH}" \
        && CROSS_COMPILE="${CROSS_COMPILE}" make distclean -j "${NBPROC}"
      ;;
    uboot)
      cd "${UBOOT_PATH}" \
        && CROSS_COMPILE="${CROSS_COMPILE}" make distclean -j "${NBPROC}"
      ;;
    *)
      echo "invalid target"
      ;;
  esac
}

# parse arguments
while [[ $# -gt 0 ]]
do
  case "$1" in
    -h|--help|help)
      print_help
      ;;
    -v|--version|version)
      print_notice
      print_version
      ;;
    -r|--repo)
      [[ $# -gt 0 ]] && export REPO="${1}"
      ;;
    -p|--prefix)
      [[ $# -gt 0 ]] && export CROSS_COMPILE="${1}"
      shift
      ;;
    --overwrite)
      export OVERWRITE=true
      shift
      ;;
    *)
      [[ -n ${1} ]] && CMD="${1}"
      break
      ;;
  esac
done

# run
[[ -z ${1} ]] && print_notice

echo """
CROSS_COMPILE:  ${CROSS_COMPILE}
OVERWRITE:        ${OVERWRITE}
"""

# run command
case "${CMD}" in
  deps)
    ./scripts/deps.sh "$@"
    ;;
  coreboot)
    ./scripts/coreboot.sh "$@"
    ;;
  opensbi)
    ./scripts/opensbi.sh "$@"
    ;;
  uboot)
    ./scripts/uboot.sh "$@"
    ;;
  onie)
    ./scripts/onie.sh "$@"
    ;;
  clean)
    clean "${2}"
    ;;
  *)
    print_help
    ;;
esac
