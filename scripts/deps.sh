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

: "${GCC_VERSION:=11}"

apt-get update -qq
apt-get autoremove -y
apt-get install -y \
  autoconf \
  automake \
  autotools-dev \
  bc \
  binutils-arm-linux-gnueabihf \
  binutils-i686-linux-gnu \
  binutils-riscv64-linux-gnu \
  binutils-x86-64-linux-gnu \
  bison \
  build-essential \
  curl \
  flex \
  gawk \
  gcc-arm-linux-gnueabihf \
  gcc-i686-linux-gnu \
  gcc-riscv64-linux-gnu \
  gcc-x86-64-linux-gnu \
  "gcc-${GCC_VERSION}-arm-linux-gnueabihf" \
  "gcc-${GCC_VERSION}-i686-linux-gnu" \
  "gcc-${GCC_VERSION}-riscv64-linux-gnu" \
  "gcc-${GCC_VERSION}-x86-64-linux-gnu" \
  "gnat-${GCC_VERSION}" \
  "gnat-${GCC_VERSION}-arm-linux-gnueabihf" \
  "gnat-${GCC_VERSION}-i686-linux-gnu" \
  "gnat-${GCC_VERSION}-riscv64-linux-gnu" \
  "gnat-${GCC_VERSION}-x86-64-linux-gnu" \
  "gnat-${GCC_VERSION}-x86-64-linux-gnux32" \
  gperf \
  lib32"gcc-${GCC_VERSION}-dev-amd64-cross" \
  lib64"gcc-${GCC_VERSION}-dev-i386-cross" \
  libexpat-dev \
  lib"gcc-${GCC_VERSION}-dev-amd64-cross" \
  lib"gcc-${GCC_VERSION}-dev-i386-cross" \
  libgmp-dev \
  lib"gnat-${GCC_VERSION}" \
  lib"gnat-${GCC_VERSION}-amd64-cross" \
  lib"gnat-${GCC_VERSION}-armhf-cross" \
  lib"gnat-${GCC_VERSION}-i386-cross" \
  lib"gnat-${GCC_VERSION}-riscv64-cross" \
  libmpc-dev \
  libmpfr-dev \
  libncurses5-dev \
  libtool \
  libx32"gcc-${GCC_VERSION}-dev-amd64-cross" \
  libx32"gcc-${GCC_VERSION}-dev-i386-cross" \
  ncurses-dev \
  ninja-build \
  patchutils \
  python3 \
  sbsigntool \
  swig \
  texinfo \
  wget \
  zlib1g-dev
