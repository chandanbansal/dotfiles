#modify mvn output
export MVN=/usr/local/bin/mvn

#colorize the maven output
# function mvn {
#     $MVN $@ | colorize.pl -f mvn
# }

function duf {
    sudo du -shk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}

#colored svn diff
function svndiff () {
  svn diff -x -b ${1+"$@"} | colordiff | less -r
}

# #git autocomplete
# if [ -f $DOTFILES/data/git-completion.bash ]; then
#   . $DOTFILES/data/git-completion.bash
# fi

#ssh with save password
#need ssh-copy-id to be installed
fssh () {
	if ! ssh -o 'PasswordAuthentication=no' "$@"; then ssh-copy-id "$@"; ssh "$@"; fi  
}

#kill all the grep matching processes
killgrep() {
    sudo kill -9 `ps -aef | grep $@ | awk '{print $2}'`
}

function stt() {
    ## set terminal title to given argument
    echo -en "\033]2;$1\007"
    #PS1=$(echo $PS1 |sed 's/^.*\\007//')
    #export PS1="\033]0;$1\007$PS1"
}

# really simple git prompt, just showing branch which is all I want. Replaced
# zsh-git-prompt as that displayed the wrong branch is some cases. I didn't
# need the other features.
function __git_prompt {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)

    if [ "$branch" ]; then
        echo -n " ($branch)"
    fi
}

function _disable_flow_control {
    # Ctrl+S can freeze the terminal, requiring
    # Ctrl+Q to restore. It can result in an apparent hung terminal, if
    # accidentally pressed.
    stty -ixon -ixoff
    # https://superuser.com/questions/385175/how-to-reclaim-s-in-zsh
    stty stop undef
    stty start undef
}

# cd then ls
function cd {
  builtin cd "$@" && ls --color=auto
}

function __exit_warn {
  # test status of last command without affecting it
  st=$?
  test $st -ne 0 \
    && printf "\n\33[31mExited with status %s\33[m" $st
}

function __p4_prompt {
  if [ "$P4CLIENT" ]; then
        echo -n " ($P4CLIENT)"
    fi
}

