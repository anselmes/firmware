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
export TARGET="onie"
export CROSS_COMPILE="riscv64-linux-gnu-"

export UBOOT_PATH="${WORKSPACE}/modules/u-boot"
export ONIE_PATH="${WORKSPACE}/modules/onie"

export CONFIG_PATH="${WORKSPACE}/config/${TARGET}"
export FIRMWARE_PATH="${WORKSPACE}/build/firmware/${TARGET}"

: "${BOARD:="qemu"}"

: "${UBOOT_CONFIG:="${CONFIG_PATH}/${BOARD}.conf"}"
: "${ONIE:="${FIRMWARE_PATH}/fw_dynamic.bin"}"

# pull onie
./cmd/run.sh onie pull

# pull uboot
./cmd/run.sh uboot pull

# TODO: build uboot
# TODO: build onie
