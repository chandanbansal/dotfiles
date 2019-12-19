#HOME Needs /usr/local/bin before /usr/bin
homebrew=/usr/local/bin:/usr/local/sbin
export PATH=$homebrew:$PATH

#for java 1.6
#Download from https://support.apple.com/kb/DL1572?locale=en_US
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)

#for java 1.7
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

#for java 1.8
export JAVA_HOME=$(/usr/libexec/java_home)


export PATH=.:/Users/chandan.bansal/Dropbox/bash/bin:/usr/local/mysql/bin:$HOME/local/node/bin:/private/var/www/node_modules/node.io/bin:$PATH:$JAVA_HOME/bin:/usr/local/go/bin
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

export PATH=$DOTFILES/bin:$PATH
source $DOTFILES/bin/quotescow

############### Improve bash history ####################

#history format, This will add timestamp to bash_history file. But when we run "history" command in terminal, it will show formated time.
#this will contradict with erasedups
export HISTTIMEFORMAT="%Y.%m.%d %H:%M:%S> "

#Don't put duplicate lines in the history
#ignoredups and ignorespace=ignoreboth
#ignore space will ignore commands starting with space
#ignoredups only ignore continous duplicates. 
#erasedups causes all previous lines matching the current line to be removed from the history list before that line is saved. But its not working somehow
HISTCONTROL=ignoredups:erasedups

HISTIGNORE="free*:pwd*:df -h*"

# Store 100000 commands in bash history
HISTFILESIZE=1000000
HISTSIZE=100000

# append history entries..
# created a .bash_logout in home with "history -a \n history -w". That works great
shopt -s histappend

# After each command, save and reload history and delete duplicates. But doesn't work with HISTTIMEFORMAT
# from http://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history/18443#18443?newreg=092a797bc79b47629a88552d4e44d3e3
#PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
############### Improve bash history ends ####################

#modify mvn output
export MVN=/usr/local/bin/mvn

#colorize the maven output
function mvn {
    $MVN $@ | colorize.pl -f mvn
}

function duf {
    sudo du -shk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}

#colored svn diff
function svndiff () {
  svn diff -x -b ${1+"$@"} | colordiff | less -r
}

#git autocomplete
if [ -f $DOTFILES/data/git-completion.bash ]; then
  . $DOTFILES/data/git-completion.bash
fi


#ssh with save password
fssh () {  if ! ssh -o 'PasswordAuthentication=no' "$@"; then ssh-copy-id "$@"; ssh "$@"; fi  }

# auto colorify the grep output
alias grep="grep --color=auto"

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

CDPATH=.:/var/www:$CDPATH

#kill all the grep matching processes
killgrep() {
    sudo kill -9 `ps -aef | grep $@ | awk '{print $2}'`
}

function stt() {
    ## set terminal title
    echo -en "\033]2;$1\007"
    #PS1=$(echo $PS1 |sed 's/^.*\\007//')
    #export PS1="\033]0;$1\007$PS1"
}


