#!/usr/bin/zsh -f
# vim: ft=zsh sw=2 sts=2 et fdm=marker cms=\ #\ %s

# Copyright (C) 2016 SUSE LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

declare -gr cmdname=$0:t

declare -gr cmdhelp=$'
usage: #c -h | --help | HOST...
List matching products
  Options:
    -h                     Display this message
    --help                 Display full help
    -v, --verbose          Enable verbose mode for scp,ssh commands

  Operands:
    HOST                   Machine to operate on
'

. ${REPOSE_PRELUDE:-@preludedir@/repose.prelude.zsh} || exit 2

function $cmdname-main # {{{
{
  local -a options; options=(
    h help
    v verbose
  )
  local on oa
  local -i oi=0

  while haveopt oi on oa $=options -- "$@"; do
    case $on in
      h | help      ) display-help $on ;;
      v | verbose   ) ssh_opt='' ;;
      *             ) reject-misuse -$oa ;;
    esac
  done; shift $oi

  (( $# )) || reject-misuse

  local -a hosts; hosts=("$@")

  local REPLY r
  local -a reply
  local h

  for h in $hosts; do
    o rh-list-products $h
    for r in $reply; do
      print -f "%s %q\n" -- $h $r
    done
  done
} # }}}

$cmdname-main "$@"
