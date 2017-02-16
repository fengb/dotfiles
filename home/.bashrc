# Check for an interactive session
[ -z "$PS1" ] && return

exist() {
  command -v "$1" &>/dev/null 2>&1
}

color() {
  printf "\[\e[$1m\]"
}

colorize() {
  printf "$(color "$2")${1}$(color 0)"
}

apply() {
export PS1="\u@$(colorize '\h' 35):$(colorize '\W' 34)$ "
export LC_COLLATE=C
local symlinkpaths=`find $HOME/bin -type l | tr "\n" ':'`
export PATH="$HOME/bin:$symlinkpaths:$PATH"

if (ls --color 2>/dev/null); then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

exist ruby && export GEM_HOME="$HOME/.gem/ruby/`ruby -v | cut -c6-10`"

[ -x /usr/libexec/java_home ] && export JAVA_HOME=`/usr/libexec/java_home 2>/dev/null`

if exist vim; then
  alias "vi=vim"
  export EDITOR=vim
else
  export EDITOR=vi
fi

local script
for script in "$HOME/.bashrc_shared"/* "$HOME/.bashrc_local"; do
  [ -r "$script" ] && source "$script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

}; apply; unset apply
