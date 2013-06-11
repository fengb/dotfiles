# Check for an interactive session
[ -z "$PS1" ] && return

exist() {
  command -v "$1" &>/dev/null 2>&1
}

apply() {
local DIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

export PS1='\u@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\W\[\e[0m\]$ '
export LC_COLLATE=C
export PATH="`find -L $DIR/bin -type d -not -path "*/.*/*" -not -name ".*" | tr '\n' ':'`$PATH"

if [ "`uname`" = Linux ]; then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

if exist vim; then
  alias "vi=vim"
  export EDITOR=vim
else
  export EDITOR=vi
fi

if exist ruby; then
  local rubyver=`ruby -v | cut -c6-8`
  export GEM_HOME=$HOME/.gem/ruby/$rubyver
fi

local script
for script in $DIR/.bash_completion/* $DIR/.bashrc_local; do
  [ -r "$script" ] && . "$script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

}; apply; unset apply
