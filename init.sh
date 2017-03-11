#!/bin/bash
#http://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
#PS4='+ \t\011 '
#exec 3>&2 2>trace.log
#set -x

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")"/home && pwd -P)"

print0() {
  tr $'\r\n' "\0\0"
}

find_filter() {
  files="`cat`"
  [ -z "$files" ] && return
  print0 <<< "$files" | xargs -0 -J {} find {} -maxdepth 0 "$@"
}

homize() {
  src="${1-`cat`}"

  if [[ "$src" == *$'\n'* ]]; then
    sed -e "s;$dir;$HOME;" -e "s/.link$//"<<< "$src"
  elif [ -n "$src" ]; then
    nolink="${src%.link}"
    echo "${HOME}${nolink#$dir}"
  fi
}

rm_files() {
  files="${1-`cat`}"
  [ -z "$files" ] && return
  sort <<< "$files"
  read -p "About to delete the above [enter to continue]: "
  echo

  print0 <<< "$files" | xargs -0 rm -rf
}

concat() {
  for arg in "$@"; do
    [ -n "$arg" ] && echo "$arg"
  done
}

run_log() {
  echo "$@"
  "$@"
}

dirnew="`find "$dir" -not \( -path '*.link' -prune \) -type d | homize`"
links="`find "$dir" \( -type d -name '*.link' -prune \) -or -type f`"

existdirs="`find_filter -not -type d <<< "$dirnew"`"
existlinks="`homize "$links" | find_filter -not -type l`"

concat "$existdirs" "$existlinks" | rm_files

while read tgt; do
  [ ! -e "$tgt" ] && run_log mkdir -p "$tgt"
done <<< "$dirnew"

while read src; do
  dst="`homize "$src"`"
  [ ! -e "$dst" ] && run_log ln -s "$src" "$dst"
done <<< "$links"
