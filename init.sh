#!/bin/bash
#http://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
#PS4='+ \t\011 '
#exec 3>&2 2>trace.log
#set -x

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")"/home && pwd -P)"
dirlinks="`find "$dir" -type f -name '.link' | sed -e 's:/.link::'`"

print0() {
  tr $'\r\n' "\0\0"
}

# Thar be magic
sep=$'\r'
esc='\'
exclusion="`sed -e "s:.*:-not$sep$esc($sep-path$sep&$sep-prune$sep$esc):" <<< "$dirlinks"`"
xfind() {
  print0 <<< "$exclusion" | xargs -0 -J {} find "$1" {} "${@:2}"
}

find_test() {
  print0 | xargs -0 -J {} find {} "$@"
}

dirnew="`xfind "$dir" -type d`"
filelinks="`xfind "$dir" -type f`"
links="$dirlinks"$'\n'"$filelinks"

homize() {
  if [[ "$1" == *$'\n'* ]]; then
    sed -e "s;$dir;$HOME;" <<< "$1"
  else
    echo "${HOME}${src#$dir}"
  fi
}

rm_files() {
  [ -z "$1" ] && return
  sort <<< "$1"
  echo -n "About to delete the above [enter to continue]: "
  read
  echo

  print0 <<< "$1" | xargs -0 rm -rf
}

run_log() {
  echo "$@"
  "#@"
}

existing="`homize "$dirnew" | find_test -prune -not -type d`"
existing+="`homize "$links" | find_test -not -type l`"

rm_files "$existing"

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
