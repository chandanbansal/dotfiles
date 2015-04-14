#HOME Needs /usr/local/bin before /usr/bin
homebrew=/usr/local/bin:/usr/local/sbin
export PATH=$homebrew:$PATH

#for java 1.6
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)

#for java 1.7
export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

#for java 1.8
#export JAVA_HOME=$(/usr/libexec/java_home)


export PATH=.:/Users/chandan.bansal/Dropbox/bash/bin:/usr/local/mysql/bin:$HOME/local/node/bin:/private/var/www/node_modules/node.io/bin:$PATH:$JAVA_HOME/bin:/usr/local/go/bin
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

export PATH=$DOTFILES/bin:$PATH
source $DOTFILES/bin/quotescow
export PATH=$PATH:/var/www/arcanist/bin
############### improve bash history ####################
#history format
export HISTTIMEFORMAT="%h %d %H:%M:%S> "

# Don't put duplicate lines in the history and remove previous duplicates
#ignoredups and ignorespace=ignoreboth
export HISTCONTROL=ignoreboth:erasedups

export HISTIGNORE="free*:pwd*:df -h*"

# Store 100000 commands in bash history
export HISTFILESIZE=100000
export HISTSIZE=100000

# append history entries..
shopt -s histappend
# After each command, save and reload history
#export PROMPT_COMMAND="history -a; history -c; history -r $PROMPT_COMMAND"
############### improve bash history ends ####################

#modify mvn output
export MVN=/usr/local/bin/mvn

#function mvn {
#    $MVN $@ | colorize.pl -f mvn
#}

function duf {
    sudo du -shk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}t${fname}"; break; fi; size=$((size/1024)); done; done
}

#colored svn diff
function svndiff () {
  svn diff -x -b ${1+"$@"} | colordiff
}

if [ -f ~/script/git-completion.bash ]; then
  . ~/script/git-completion.bash
fi


#ssh with save password
fssh () {  if ! ssh -o 'PasswordAuthentication=no' "$@"; then ssh-copy-id "$@"; ssh "$@"; fi  }

# auto colorify the grep output
alias grep="grep --color=auto"

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

CDPATH=.:/var/www:$CDPATH

killgrep() {
    sudo kill -9 `ps -aef | grep $@ | awk '{print $2}'`
}

function stt() {
    ## set terminal title
    echo -en "\033]2;$1\007"
    #PS1=$(echo $PS1 |sed 's/^.*\\007//')
    #export PS1="\033]0;$1\007$PS1"
}


