# Check for an interactive session
[ -z "$PS1" ] && return

exist() {
  command -v "$1" &>/dev/null 2>&1
}

apply() {
export PS1='\u@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\W\[\e[0m\]$ '
export LC_COLLATE=C
local symlinkpaths=`find $HOME/bin -type l | tr "\n" ':'`
export PATH="$HOME/bin:$symlinkpaths:$PATH"

if (ls --color 2>/dev/null); then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

exist brew && export BREW_HOME=`brew --prefix`
exist ruby && export GEM_HOME="$HOME/.gem/ruby/`ruby -v | cut -c6-10`"
[ -x /usr/libexec/java_home ] && export JAVA_HOME=`/usr/libexec/java_home 2>/dev/null`
[ -r $BREW_HOME/android-sdk ] && export ANDROID_HOME="$BREW_HOME/opt/android-sdk"

if exist vim; then
  alias "vi=vim"
  export EDITOR=vim
else
  export EDITOR=vi
fi


[ -d $BREW_HOME/include ] && export CPATH="$BREW_HOME/include"

if [ -d $BREW_HOME/lib ]; then
  export LIBRARY_PATH="$BREW_HOME/lib"
  export LD_LIBRARY_PATH="$BREW_HOME/lib"
fi

local script
for script in "$HOME/.bashrc_shared"/* "$HOME/.bashrc_local"; do
  [ -r "$script" ] && source "$script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

}; apply; unset apply
