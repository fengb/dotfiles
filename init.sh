#!/bin/bash
#http://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
#PS4='+ \t\011 '
#exec 3>&2 2>trace.log
#set -x

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")"/home && pwd -P)"
#echo "$(cd "`dirname "${BASH_SOURCE[0]}`" && git rev-parse --show-toplevel)"
#exit

print0() {
  tr $'\r\n' "\0\0"
}

find_filter() {
  files="`cat`"
  [ -z "$files" ] && return
  print0 <<< "$files" | xargs -0 -J {} find {} -maxdepth 0 "$@"
}

as_home() {
  sed -e "s;^$dir;$HOME;" -e "s/.link$//"
}

as_src() {
  src="${dir}${1#$HOME}"
  [ -e "$src" ] && echo "$src" || echo "$src.link"
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
  echo "$@" && "$@"
}

#find -L "$HOME" -not \( -not -path "$HOME" -prune \) -type l

dirnew="`find "$dir" -not \( -path '*.link' -prune \) -type d | as_home`"
links="`find "$dir" \( -type d -name '*.link' -prune \) -or -type f | as_home`"

existdirs="`find_filter -not -type d <<< "$dirnew"`"
existlinks="`find_filter -not -type l <<< "$links"`"

concat "$existdirs" "$existlinks" | rm_files

while read -r dst; do
  [ ! -e "$dst" ] && run_log mkdir -p "$dst"
done <<< "$dirnew"

while read -r dst; do
  [ ! -e "$dst" ] && run_log ln -s "`as_src "$dst"`" "$dst"
done <<< "$links"
