# Check for an interactive session
[ -z "$PS1" ] && return

exist() {
  command -v "$1" &>/dev/null
}

color() {
  printf "\[\e[$1m\]"
}

colorize() {
  printf "$(color "$2")${1}$(color 0)"
}

export PS1="\u@$(colorize '\h' 35):$(colorize '\W' 34)$ "
export LC_COLLATE=C
export PATH="$(find -L $HOME/bin -maxdepth 1 -type d | paste -s -d : -):$PATH"

if (ls --color 2>/dev/null); then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

alias "ppid=ps -o ppid= -p"

[ -x /usr/libexec/java_home ] && export JAVA_HOME="`/usr/libexec/java_home -F 2>/dev/null`"

if exist vim; then
  alias "vi=vim"
  export EDITOR=vim
else
  export EDITOR=vi
fi

for _t_script in "$HOME/.bashrc_shared"/* "$HOME/.bashrc_local"; do
  [ -r "$_t_script" ] && source "$_t_script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

# Delete temporary variables
unset ${!_t_*}
