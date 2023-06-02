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

OP="${1}"

# copy artifacts
case "${OP}" in
  onie)
    echo "TODO: copying onie artifacts..."
    ;;
  uboot)
    DTB="${UBOOT_PATH}/u-boot.dtb"
    UBOOT="${UBOOT_PATH}/u-boot.bin"
    UBOOT_ELF="${UBOOT_PATH}/u-boot"

    echo """
DTB:           ${DTB}
U-Boot:        ${UBOOT}
U-Boot (elf):  ${UBOOT_ELF}
    """

    if [[ "${OVERWRITE}" == true && -f "${DTB}" && -f "${UBOOT}" && -f "${UBOOT_ELF}" ]]
    then
      echo "copying artifacts (overwriting if exists)..."
      cp -f "${DTB}" "${FIRMWARE_PATH}/u-boot.dtb"
      cp -f "${UBOOT}" "${FIRMWARE_PATH}/u-boot.bin"
      cp -f "${UBOOT_ELF}" "${FIRMWARE_PATH}/u-boot.elf"
    elif [[ -f "${DTB}" && -f "${UBOOT}" && -f "${UBOOT_ELF}" ]]
    then
      echo "copying artifacts..."
      cp "${DTB}" "${FIRMWARE_PATH}/u-boot.dtb"
      cp "${UBOOT}" "${FIRMWARE_PATH}/u-boot.bin"
      cp "${UBOOT_ELF}" "${FIRMWARE_PATH}/u-boot.elf"
    else
      echo "no artifacts built!"
      exit 1
    fi
    ;;
  coreboot)
    COREBOOT="${COREBOOT_PATH}/build/coreboot.rom"
    echo "COREBOOT: ${COREBOOT}"
    if [[ "${OVERWRITE}" == true && -f "${COREBOOT}" ]]
    then
      echo "copying artifacts (overwriting if exists)..."
      cp -f "${COREBOOT}" "${FIRMWARE_PATH}/coreboot.rom"
    elif [[ -f "${COREBOOT}" ]]
    then
      echo "copying artifacts..."
      cp "${COREBOOT}" "${FIRMWARE_PATH}/coreboot.rom"
    else
      echo "no artifacts built!"
      exit 1
    fi
    ;;
  opensbi)
    OPENSBI="${OPENSBI_PATH}/build/platform/generic/firmware/fw_dynamic.bin"
    echo "OPENSBI: ${OPENSBI}"
    if [[ "${OVERWRITE}" == true && -f "${OPENSBI}" ]]
    then
      echo "copying artifacts (overwriting if exists)..."
      cp -f "${OPENSBI}" "${FIRMWARE_PATH}/fw_dynamic.bin"
    elif [[ -f "${OPENSBI}" ]]
    then
      echo "copying artifacts..."
    else
      echo "no artifacts built!"
      exit 1
    fi
    ;;
  *)
    echo "invalid"
    ;;
esac
