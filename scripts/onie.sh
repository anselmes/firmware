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

: "${REPO:="https://github.com/anselmes/onie.git"}"

# help
print_help()
{
  echo """
Usage: onie [CMD]

Commands:
  pull    Pull onie repo.
  build   Build onie.
  copy    Copy onie to output directory.
"""
  exit 0
}

# build
build()
{
  [[ ${OVERWRITE} == true ]] && CROSS_COMPILE="${CROSS_COMPILE}" make distclean

  echo "TODO: building onie..."
}

# parse args
while [[ $# -gt 0 ]]
do
  case "$2" in
    pull)
      echo "pulling onie..."
      ! [[ -d ./modules/onie ]] && git clone "${REPO}" ./modules/onie
      break
      ;;
    build)
      build
      break
      ;;
    copy)
      "${COPY_CMD}" onie
      break
      ;;
    *)
      break
      ;;
  esac
done

# run
[[ -z ${2} ]] && print_help
