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
: "${U_BOOT_PATH:="/workspace/modules/u-boot"}"
: "${COMPILER_PREFIX:="x86_64-linux-gnu-"}"
: "${OVERWRITE:=false}"

# help
print_help()
{
  echo """
Usage: uboot [OPTIONS] [CMD] [ARGS]

Commands:
  pull            Pull u-boot repo
  build <target>  Build uboot
  copy            Copy artifacts (build/dtb/ build/firmware/ build/kernel/)

Options:
  -p, --prefix  Cross compiller prefix (default: x86_64-linux-gnu-)
  --overwrite   Overwrite operation (default: false)
"""
  exit 0
}

build()
{
  TARGET="${1}"
  echo """
COMPILER_PREFIX:  ${COMPILER_PREFIX}
TARGET:           ${TARGET}
"""

  if [[ -z ${TARGET} ]]
  then
    echo "missing target!"
    exit 1
  else
    NBPROC="$(nproc)"
    echo "building uboot for ${TARGET} using ${COMPILER_PREFIX}gcc..."
    cd "${U_BOOT_PATH}" \
      && CROSS_COMPILE=${COMPILER_PREFIX} make -j "${TARGET}"_defconfig \
      && CROSS_COMPILE=${COMPILER_PREFIX} make -j "${NBPROC}" \
      && copy_artifact
    exit 0
  fi
}

copy_artifact()
{
  DTB="${U_BOOT_PATH}/u-boot.dtb"
  UBOOT="${U_BOOT_PATH}/u-boot.bin"
  UBOOT_DTB="${U_BOOT_PATH}/u-boot-dtb.bin"
  UBOOT_ELF="${U_BOOT_PATH}/u-boot"

  DTB_PATH="/workspace/build/dtb"
  FIRMWARE_PATH="/workspace/build/firmware"
  KERNEL_PATH="/workspace/build/kernel"

  echo """
DTB:           ${DTB}
U-Boot         ${UBOOT}
U-Boot (dtb):  ${UBOOT_DTB}
U-Boot (elf):  ${UBOOT_ELF}
  """

  if [[ -f "${DTB}" && -f "${UBOOT}" && -f "${UBOOT_DTB}" && -f "${UBOOT_ELF}" && "${OVERWRITE}" == true ]]
  then
    echo "copying artifacts (overwriting if exists)..."
    cp -f "${DTB}" "${DTB_PATH}/"
    cp -f "${UBOOT}" "${UBOOT_DTB}" "${FIRMWARE_PATH}/"
    cp -f "${UBOOT_ELF}" "${KERNEL_PATH}/"
  elif [[ -f "${DTB}" && -f "${UBOOT}" && -f "${UBOOT_DTB}" && -f "${UBOOT_ELF}" ]]
  then
    echo "copying artifacts..."
    cp "${DTB}" "${DTB_PATH}/" || true
    cp "${UBOOT}" "${UBOOT_DTB}" "${FIRMWARE_PATH}/" || true
    cp "${UBOOT_ELF}" "${KERNEL_PATH}/" || true
  else
    echo "no artifacts built!"
    exit 1
  fi
}

while [[ $# -gt 0 ]]
do
  case "$2" in
    -p|--prefix)
      [[ $# -gt 0 ]] && export COMPILER_PREFIX="${1}"
      shift
      ;;
    --overwrite)
      export OVERWRITE=true
      shift
      ;;
    pull)
      echo "pulling uboot..."
      ! [[ -d "${U_BOOT_PATH}" ]] && git clone "${REPO}" "${U_BOOT_PATH}"
      break
      ;;
    build)
      [[ $# -gt 2 ]] && TARGET="${3}"
      [[ $# -gt 0 ]] && build "${TARGET}"
      ;;
    copy)
      copy_artifact
      break
      ;;
    *)

      break
      ;;
  esac
done

# run
[[ -z ${2} ]] && print_help
