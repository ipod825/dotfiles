source ~/.profile

##OPTIONS
#history
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000

# Save and reload history after each command finishes
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

############## GENERAL UI ################
force_color_prompt=yes

# Vim key-bindings
set -o vi

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# PROMPT_COMMAND=""
# PS1="\[$(tput setaf 39)\]\h :\[$(tput setaf 111)\]\W \[$(tput sgr0)\]"

host_prompt="$(tput setaf 39)`hostname`"
set_ps1() {
    sedcmd="s/\/\home\/$USER/~/g"
    directory_prompt="$(tput setaf 111):"`pwd | sed $sedcmd | sed "s:\([^/]\)[^/]*/:\1/:g"`
    PS1="$VI_MODE$host_prompt $directory_prompt "
}

trap set_ps1 DEBUG        # calls the function before each command

PROMPT_COMMAND=set_ps1    # calls the function after each command

# These two binding only has effect if put in .inputrc
# bind "\e[A":history-substring-search-forward
# bind "\e[B":history-substring-search-backward

bind "\C-j":history-substring-search-forward
bind "\C-k":history-substring-search-backward

bind "^[h":beginning-of-line
bind "^[l":end-of-line
bind "JK":vi-movement-mode
bind "TAB":menu-complete
bind "\e[Z":menu-complete-backward

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
