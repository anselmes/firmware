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
export TARGET="coreboot"
export CROSS_COMPILE="i686-linux-gnu-"

export UBOOT_PATH="${WORKSPACE}/modules/u-boot"
export COREBOOT_PATH="${WORKSPACE}/modules/coreboot"

export CONFIG_PATH="${WORKSPACE}/config/${TARGET}"
export FIRMWARE_PATH="${WORKSPACE}/build/firmware/${TARGET}"

: "${BOARD:="QEMU"}"
# : "${BOARD:="Z220SFF"}"

: "${UBOOT_CONFIG:="${CONFIG_PATH}/uboot.conf"}"
: "${COREBOOT_CONFIG:="${CONFIG_PATH}/${BOARD}-coreboot.conf"}"

# pull uboot
./cmd/run.sh uboot pull || false

# pull coreboot
./cmd/run.sh coreboot pull || false

# build uboot as coreboot payload
cp -fv "${UBOOT_CONFIG}" "${UBOOT_PATH}/.config"
./cmd/run.sh uboot build coreboot

mv -fv "${COREBOOT_PATH}/payloads/external/U-Boot" "${COREBOOT_PATH}/payloads/external/U-Boot.bak"
ln -sfv "${UBOOT_PATH}" "${COREBOOT_PATH}/payloads/external/U-Boot"

./cmd/run.sh uboot copy
ITEMS=( $(ls "${FIRMWARE_PATH}"/u-boot*) ) || false
for item in ${ITEMS}
do
  mv -fv "${item}" "${item%/*}/fw_${TARGET}_payload.${item##*.}"
done

# FIXME: build coreboot
cp -fv "${COREBOOT_CONFIG}" "${COREBOOT_PATH}/.config"
./cmd/run.sh coreboot build
./cmd/run.sh coreboot copy
mv -fv "${FIRMWARE_PATH}/coreboot.rom" "${FIRMWARE_PATH}/fw_${BOARD}.rom"

# TODO: clean up
# ./cmd/run.sh clean uboot
# ./cmd/run.sh clean coreboot
# rm -rf "${COREBOOT_PATH}/payloads/external/U-Boot"
# mv -rf "${COREBOOT_PATH}/payloads/external/U-Boot.bak" "${COREBOOT_PATH}/payloads/external/U-Boot"
