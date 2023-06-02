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

: "${REPO:="https://github.com/anselmes/u-boot.git"}"

# help
print_help()
{
  echo """
Usage: uboot [CMD] [TARGET]

Commands:
  pull              Pull uboot repo.
  build <target>    Build uboot (coreboot, opensbi, onie).
  copy              Copy uboot to output directory.
"""
  exit 0
}

# build
build()
{
  export TARGET="${1}"
  echo """
TARGET:           ${TARGET}
"""

  mkdir -p "${FIRMWARE_PATH}"
  [[ ${OVERWRITE} == true ]] && CROSS_COMPILE="${CROSS_COMPILE}" make distclean

  if [[ -z ${TARGET} ]]
  then
    echo "missing target!"
    exit 1
  else
    echo "building uboot for ${TARGET} using ${CROSS_COMPILE}gcc..."
    case "${TARGET}" in
      coreboot)
        cd "${UBOOT_PATH}" \
          && CROSS_COMPILE="${CROSS_COMPILE}" make -j "${NBPROC}"
        ;;
      opensbi)
        cd "${UBOOT_PATH}" \
          && CROSS_COMPILE="${CROSS_COMPILE}" OPENSBI="${OPENSBI}" make -j "${NBPROC}"
        ;;
      onie)
        echo "TODO: building uboot for onie..."
        ;;
      *)
        echo "unknown target!"
        exit 1
        ;;
    esac
    exit 0
  fi
}

# parse args
while [[ $# -gt 0 ]]
do
  case "$2" in
    pull)
      echo "pulling uboot..."
      ! [[ -d "${UBOOT_PATH}" ]] && git clone "${REPO}" "${UBOOT_PATH}"
      break
      ;;
    build)
      if [[ $# -lt 3 ]]
      then
        echo "missing target!"
        exit 1
      fi
      export FIRMWARE_PATH="${UBOOT_PATH}/build/firmware/${TARGET}"
      [[ $# -gt 0 ]] && build "${TARGET}"
      ;;
    copy)
      "${COPY_CMD}" uboot
      break
      ;;
    *)
      break
      ;;
  esac
done

# run
[[ -z ${2} ]] && print_help
