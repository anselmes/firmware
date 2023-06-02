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

export WORKSPACE="/workspace"
export TARGET="opensbi"
export CROSS_COMPILE="riscv64-linux-gnu-"

export UBOOT_PATH="${WORKSPACE}/modules/u-boot"
export OPENSBI_PATH="${WORKSPACE}/modules/opensbi"

export CONFIG_PATH="${WORKSPACE}/config/${TARGET}"
export FIRMWARE_PATH="${WORKSPACE}/build/firmware/${TARGET}"

: "${BOARD:="qemu"}"
# : "${BOARD:="visionfive2"}"

: "${UBOOT_CONFIG:="${CONFIG_PATH}/${BOARD}.conf"}"
: "${OPENSBI:="${FIRMWARE_PATH}/fw_dynamic.bin"}"

# pull opensbi
./cmd/run.sh opensbi pull

# pull uboot
./cmd/run.sh uboot pull

# build opensbi
./cmd/run.sh opensbi build
./cmd/run.sh opensbi copy

# build uboot with opensbi payload
cp -fv "${UBOOT_CONFIG}" "${UBOOT_PATH}/.config"
./cmd/run.sh uboot build opensbi

./cmd/run.sh uboot copy
ITEMS=( $(ls "${FIRMWARE_PATH}"/u-boot*) ) || false
for item in ${ITEMS}
do
  mv -fv "${item}" "${item%/*}/fw_${TARGET}.${item##*.}"
done

# clean up
rm -rf "${U_BOOT_PATH}/spl"

./cmd/run.sh clean opensbi
./cmd/run.sh clean uboot
