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

: "${REPO:="https://github.com/anselmes/coreboot.git"}"

# help
print_help()
{
  echo """
Usage: coreboot [OPTIONS] [CMD]

Commands:
  pull    Pull coreboot repo.
  build   Build coreboot.
  copy    Copy coreboot to output directory.

Options:
  -gcc    Build crossgcc.
  -iasl   Build iasl.
"""
  exit 0
}

# build
build()
{
  [[ ${OVERWRITE} == true ]] && CROSS_COMPILE="${CROSS_COMPILE}" make distclean

  if [[ ${BUILD_CROSSGCC} == true ]]
  then
    echo "building crossgcc..."
    cd "${COREBOOT_PATH}" \
        && CROSS_COMPILE="${CROSS_COMPILE}" make crossgcc -j "${NBPROC}"
  fi

  if [[ ${BUILD_IASL} == true ]]
  then
    echo "building iasl..."
    cd "${COREBOOT_PATH}" \
        && CROSS_COMPILE="${CROSS_COMPILE}" make iasl -j "${NBPROC}"
  fi

  echo "building coreboot..."
  cd "${COREBOOT_PATH}" \
      && CROSS_COMPILE="${CROSS_COMPILE}" make -j "${NBPROC}"
}

# parse args
while [[ $# -gt 0 ]]
do
  case "$2" in
    -gcc)
      echo "enable building crossgcc..."
      export BUILD_CROSSGCC=true
      shift
      ;;
    -iasl)
      echo "enable building iasl..."
      export BUILD_IASL=true
      shift
      ;;
    pull)
      echo "pulling coreboot..."
      if ! [[ -d "${COREBOOT_PATH}" ]]
      then
         git clone "${REPO}" "${COREBOOT_PATH}"
         cd "${COREBOOT_PATH}" \
          && sed -i 's/url = ../url = https:\/\/github.com\/coreboot/g' modules/coreboot/.gitmodules \
          && git submodule sync \
          && git submodule update --init --checkout --recursive
      fi
      break
      ;;
    build)
      build
      break
      ;;
    copy)
      "${COPY_CMD}" coreboot
      break
      ;;
    *)
      print_help
      break
      ;;
  esac
done

# run
[[ -z ${2} ]] && print_help
