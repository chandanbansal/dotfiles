#export PATH=.:/Users/chandan.bansal/Dropbox/bash/bin:/usr/local/mysql/bin:$HOME/local/node/bin:/private/var/www/node_modules/node.io/bin:$PATH:$JAVA_HOME/bin:/usr/local/go/bin
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

export HOME=~
export GOPATH=$HOME/gocode
export PATH=$HOME/.local/bin:$PATH
export EDITOR=vim-wrapper
#export PATH=$DOTFILES/bin:$PATH
export LANG=en_IN.UTF-8
export LC_ALL=en_US.UTF-8

#HOME Needs /usr/local/bin before /usr/bin
#homebrew=/usr/local/bin:/usr/local/sbin
#export PATH=$homebrew:$PATH

#for java 1.6
#Download from https://support.apple.com/kb/DL1572?locale=en_US
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)

#for java 1.7
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

#for java 1.8
export JAVA_HOME=$(/usr/libexec/java_home)
CDPATH=.:/var/www:$CDPATH


# Sometimes not set or fully qualified; simple name preferred.
export HOSTNAME=$(hostname -s)

# export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

# export GCC_COLORS=1
# export SYSTEM_COLOUR=$($HOME/.local/bin/system-colour $HOSTNAME)

# if [[ $USER == root ]]; then
#    PROMPT_COLOUR=160 # red
# else
#    PROMPT_COLOUR=$SYSTEM_COLOUR
# fi

HISTSIZE=200000
HISTFILE=~/.history


if [ -f ~/.env-local.sh ]; then
    source ~/.env-local.sh
fi
