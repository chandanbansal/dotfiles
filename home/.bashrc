source ~/.env.sh
source ~/.functions.sh
source ~/.aliases

#source $DOTFILES/bin/quotescow
############### Improve bash history ####################

#history format, This will add timestamp to bash_history file. But when we run "history" command in terminal, it will show formated time.
#this will contradict with erasedups
export HISTTIMEFORMAT="%Y.%m.%d %H:%M:%S> "

#Don't put duplicate lines in the history
#ignoredups and ignorespace=ignoreboth
#ignore space will ignore commands starting with space
#ignoredups only ignore continous duplicates. 
#erasedups causes all previous lines matching the current line to be removed from the history list before that line is saved. But its not working somehow
HISTCONTROL=ignoredups:ignorespace:erasedups

HISTIGNORE="free*:pwd*:df -h*"

# Store 100000 commands in bash history
HISTFILESIZE=1000000
HISTSIZE=100000

# append history entries..
# created a .bash_logout in home with "history -a \n history -w". That works great

# update the values of LINES and COLUMNS. Automatically
shopt -s checkwinsize

shopt -s histappend

HISTFILESIZE=$HISTSIZE
# After each command, save and reload history and delete duplicates. But doesn't work with HISTTIMEFORMAT
# from http://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history/18443#18443?newreg=092a797bc79b47629a88552d4e44d3e3
#PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
############### Improve bash history ends ####################

# if you call a different shell, this does not happen automatically. WTF?
export SHELL=$(which bash)

#PS1="
#\$(__exit_warn)
#\[\e[36m\]\${CMD_TIMER_PROMPT}\[\e[38;5;${PROMPT_COLOUR}m\]\u@\H:\$PWD\[\e[38;5;243m\]\$(__git_prompt)\$(__p4_prompt)\[\e[0m\]
#\$ "

# fix backspace on some terminals
stty erase ^?

_disable_flow_control


# Source bash completions
# see https://discourse.brew.sh/t/bash-completion-2-vs-brews-auto-installed-bash-completions/2391/4
# for discussion. Mac requires brew packages bash and bash-completion@2
if [[ -e "/usr/local/share/bash-completion/bash_completion" ]]; then
    # mac os, new (jit) and few remaining old style completions (git!)
	export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
	source "/usr/local/share/bash-completion/bash_completion"
elif [[ -e "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
    # mac os, new style completions only
	source "/usr/local/etc/profile.d/bash_completion.sh"
elif [[ -e "/etc/bash_completion" ]]; then
    # standard on linux systems, sources from /etc/bash_completion.d/
	source "/etc/bash_completion"
fi
