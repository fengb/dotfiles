#!/bin/bash
#http://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
#PS4='+ \t\011 '
#exec 3>&2 2>trace.log
#set -x

base="$(cd "`dirname "${BASH_SOURCE[0]}"`" && git rev-parse --show-toplevel)"
dir="$base/home"

print0() {
  tr $'\r\n' "\0\0"
}

find_filter() {
  files="`cat`"
  [ -z "$files" ] && return
  if [ "$1" = "-L" ]; then
    arg="$1"
    shift
    print0 <<< "$files" | xargs -0 -J {} find "$arg" {} -maxdepth 0 "$@" 2> /dev/null
  else
    print0 <<< "$files" | xargs -0 -J {} find {} -maxdepth 0 "$@" 2> /dev/null
  fi
}

as_home() {
  sed -e "s;^$dir;$HOME;" -e "s/.link$//"
}

as_src() {
  src="${dir}${1#$HOME}"
  [ -e "$src" ] && echo "$src" || echo "$src.link"
}

rm_files() {
  files="`concat "$@" | sort -u`"
  [ -z "$files" ] && return
  echo "$files"
  read -p "About to delete [enter to continue]: "
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

git_historic_files() {
  git log --pretty=format: --name-only --diff-filter=A | sed -e '/^ *$/d' -e "s;^;$base/;" | sort -u
}

#find -L "$HOME" -not \( -not -path "$HOME" -prune \) -type l

dirnew="`find "$dir" -not \( -path '*.link' -prune \) -type d | as_home`"
links="`find "$dir" \( -type d -name '*.link' -prune \) -or -type f | as_home`"

existdirs="`find_filter -not -type d <<< "$dirnew"`"
existlinks="`find_filter -not -type l <<< "$links"`"
brokelinks="`git_historic_files | as_home | find_filter -L -maxdepth 0 -type l`"

rm_files "$existdirs" "$existlinks" "$brokelinks"

while read -r dst; do
  [ ! -e "$dst" ] && run_log mkdir -p "$dst"
done <<< "$dirnew"

while read -r dst; do
  [ ! -e "$dst" ] && run_log ln -s "`as_src "$dst"`" "$dst"
done <<< "$links"
