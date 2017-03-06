#!/bin/bash
#http://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
#PS4='+ \t\011 '
#exec 3>&2 2>trace.log
#set -x

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")"/home && pwd -P)"

print0() {
  tr $'\r\n' "\0\0"
}

find_test() {
  print0 | xargs -0 -J {} find {} "$@"
}

homize() {
  if [[ "$1" == *$'\n'* ]]; then
    sed -e "s;$dir;$HOME;" -e "s/.link$//"<<< "$1"
  else
    nolink="${src%.link}"
    echo "${HOME}${nolink#$dir}"
  fi
}

rm_files() {
  [ -z "$1" ] && return
  sort <<< "$1"
  read -p "About to delete the above [enter to continue]: "
  echo

  print0 <<< "$1" | xargs -0 rm -rf
}

run_log() {
  echo "$@"
  "$@"
}

dirlinks="`find "$dir" -type d -name '*.link'`"
dirnew="`find "$dir" -not \( -path '*.link' -prune \) -type d`"
filelinks="`find "$dir" -not \( -path '*.link' -prune \) -type f`"
links="$dirlinks"$'\n'"$filelinks"

existdirs="`homize "$dirnew" | find_test -prune -not -type d`"
existfiles="`homize "$links" | find_test -not -type l`"

rm_files "$existdirs$existfiles"

homize "$dirnew" | while read dst; do
  if [ ! -e "$dst" ]; then
    run_log mkdir -p "$dst"
  fi
done

while read src; do
  dst="`homize "$src"`"
  if [ ! -e "$dst" ]; then
    run_log ln -s "$src" "$dst"
  fi
done <<< "$links"
