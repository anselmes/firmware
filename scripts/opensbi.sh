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

: "${REPO:="https://github.com/anselmes/opensbi.git"}"

# help
print_help()
{
  echo """
Usage: opensbi [CMD]

Commands:
  pull    Pull opensbi repo.
  build   Build opensbi.
  copy    Copy opensbi to output directory.
"""
  exit 0
}

# build
build()
{
  [[ ${OVERWRITE} == true ]] && CROSS_COMPILE="${CROSS_COMPILE}" make distclean

  echo "building opensbi..."
  cd "${OPENSBI_PATH}" \
        && make \
        CROSS_COMPILE="${CROSS_COMPILE}" \
        PLATFORM=generic \
        FW_TEXT_START=0x40000000 \
        FW_OPTIONS=0 \
        -j "${NBPROC}"
}

# parse args
while [[ $# -gt 0 ]]
do
  case "$2" in
    pull)
      echo "pulling opensbi..."
      ! [[ -d ./modules/opensbi ]] && git clone "${REPO}" ./modules/opensbi
      break
      ;;
    build)
      build
      break
      ;;
    copy)
      "${COPY_CMD}" opensbi
      break
      ;;
    *)
      break
      ;;
  esac
done

# run
[[ -z ${2} ]] && print_help
