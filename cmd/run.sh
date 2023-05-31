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

# notice
print_notice()
{
  echo """
Copyright (C) 2023  Schubert Anselme <schubert@anselm.es>
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions.
  """
}

# help
print_help()
{
  echo """
Usage: run [OPTIONS] CMD [ARGS]

Commands:
  deps                    Dependency commands (requires root permission)
  coreboot                Coreboot commands
  opensbi                 OpenSBI commands
  uboot                   U-Boot commands

Options:
  -h, --help, help        Print this help
  -v, --version, version  Print verion information
  """
  exit 0
}

# version
print_version()
{
  echo "Version: 0.0.1"
  exit 0
}

while [[ $# -gt 0 ]]
do
  case "$1" in
    -h|--help|help)
      print_help
      ;;
    -v|--version|version)
      print_notice
      print_version
      ;;
    -r|--repo)
      [[ $# -gt 0 ]] && export REPO="${1}"
      ;;
    *)
      [[ -n ${1} ]] && CMD="${1}"
      break
      ;;
  esac
done

# run
[[ -z ${1} ]] && print_help

# FIXME: move pulling repo to deps
case "${CMD}" in
  deps)
    ./scripts/deps.sh "$@"
    ;;
  coreboot)
    ./scripts/coreboot.sh "$@"
    ;;
  opensbi)
    ./scripts/opensbi.sh "$@"
    ;;
  uboot)
    ./scripts/uboot.sh "$@"
    ;;
  *)
    echo "invalid command"
    ;;
esac
