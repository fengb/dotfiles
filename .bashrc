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
export PATH="$([ -d "$HOME/bin" ] && { find -L "$HOME/bin" -depth 1 -type d | xargs readlink; echo "$HOME/bin"; } | paste -s -d : -):$PATH"
export LS_COLORS='ex=00:su=00:sg=00:ca=00:'
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export BASH_SILENCE_DEPRECATION_WARNING=1

alias "bashrc-reset=source ~/.bashrc"

if (ls --color 2>/dev/null); then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

alias "ppid=ps -o ppid= -p"

export JAVA_HOME="$(/usr/libexec/java_home -F 2>/dev/null)"

if exist nvim; then
  alias "vi=nvim"
  alias "vim=nvim"
  export EDITOR=vim
elif exist vim; then
  alias "vi=vim"
  export EDITOR=vim
else
  export EDITOR=vi
fi

if exist sysctl; then
  export CPUS="$(sysctl -n hw.ncpu)"
else
  export CPUS="$(nproc --all)"
fi

alias m8ke="make -j $CPUS"

export ASDF_DATA_DIR="/opt/asdf"

for _t_script in "$HOME/.bashrc_shared"/* "$HOME/.asdf/asdf.sh" "$HOME/.asdf/completions/asdf.bash" "$HOME/.nix-profile/etc/profile.d/nix.sh" "$HOME/.bashrc_local"; do
  [ -r "$_t_script" ] && source "$_t_script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

# Delete temporary variables
unset ${!_t_*}
