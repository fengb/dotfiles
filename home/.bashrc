# Check for an interactive session
[ -z "$PS1" ] && return

apply() {

local user='\u'
local host='\h'
local path='\W'

local cblk='\[\e[0;30m\]'
local cred='\[\e[0;31m\]'
local cgrn='\[\e[0;32m\]'
local cylw='\[\e[0;33m\]'
local cblu='\[\e[0;34m\]'
local cpur='\[\e[0;35m\]'
local ccyn='\[\e[0;36m\]'
local cwht='\[\e[0;37m\]'
local cbblk='\[\e[1;30m\]'
local cbred='\[\e[1;31m\]'
local cbgrn='\[\e[1;32m\]'
local cbylw='\[\e[1;33m\]'
local cbblu='\[\e[1;34m\]'
local cbpur='\[\e[1;35m\]'
local cbcyn='\[\e[1;36m\]'
local cbwht='\[\e[1;37m\]'
local cublk='\[\e[4;30m\]'
local cured='\[\e[4;31m\]'
local cugrn='\[\e[4;32m\]'
local cuylw='\[\e[4;33m\]'
local cublu='\[\e[4;34m\]'
local cupur='\[\e[4;35m\]'
local cucyn='\[\e[4;36m\]'
local cuwht='\[\e[4;37m\]'
local creset='\[\e[0m\]'

export PS1="${user}@${cred}${host}${creset}:${cbblu}${path}${creset}\$ "

export EDITOR=/usr/bin/vi
export LC_COLLATE=C

export PATH="`find -L ~/bin -type d -not -path "*/.*/*" -not -name ".*" | tr '\n' ':'`$PATH"
if command -v gem >&/dev/null 2>&1; then
  export GEM_HOME=`gem env | sed -e "\;- $HOME;!d" -e 's/.*- //'`
fi

if [ "`uname`" = Linux ]; then
  alias "ls=ls --color"
else
  alias "ls=ls -G"
fi

local script
for script in /etc/bash_completion ~/.bash_completion/* ~/.bashrc_local; do
  [ -r "$script" ] && . "$script"
done

# Make bash check its window size after a process completes
shopt -s checkwinsize

}; apply; unset apply
