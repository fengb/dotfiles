# Check for an interactive session
[ -z "$PS1" ] && return

exist() {
  command -v "$1" &>/dev/null 2>&1
}

apply() {
local DIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

export PS1='\u@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\W\[\e[0m\]$ '
export LC_COLLATE=C
for dir in `find -L $DIR/bin -type d -not -path "*/.*/*" -not -name ".*"`; do
  export PATH="`readlink "$dir" || echo "$dir"`:$PATH"
done
exist brew && BREW_HOME=`brew --prefix`

if [ "`uname`" = Linux ]; then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

if [ -e /usr/libexec/java_home ]; then
  export JAVA_HOME=`/usr/libexec/java_home 2>&-`
fi

if exist vim; then
  alias "vi=vim"
  export EDITOR=vim
else
  export EDITOR=vi
fi

if exist ag; then
  alias "ack=ag"
elif exist ack-grep; then
  alias "ack=ack-grep"
  alias "ag=ack-grep"
elif exist ack; then
  alias "ag=ack"
fi

if [ -r $BREW_HOME/share/chruby/chruby.sh ]; then
  source $BREW_HOME/share/chruby/chruby.sh
  chruby `chruby | tail -n 1`
elif exist ruby; then
  local rubyver=`ruby -v | cut -c6-10`
  export GEM_HOME=$HOME/.gem/ruby/$rubyver
fi

[ -r $BREW_HOME/etc/profile.d/z.sh ] && source $BREW_HOME/etc/profile.d/z.sh
[ -r $BREW_HOME/include ] && export CPATH=$BREW_HOME/include
[ -r $BREW_HOME/lib ] && export LIBRARY_PATH=$BREW_HOME/lib

local script
for script in $DIR/.bash_completion/* $DIR/.bashrc_local; do
  [ -r "$script" ] && source "$script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

}; apply; unset apply
