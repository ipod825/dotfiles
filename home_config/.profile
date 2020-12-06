#!/bin/sh
# Profile file. Runs on shell login. We also source this file in ~/.xsession and
# ~/.xsesionrc to have the same environment when logging in with X.

stty -ixon # free C-q for other binding

# path
function addToPATH {
  case ":$PATH:" in
    *":$1:"*) :;; # already there
    *) PATH="$1:$PATH";; # or PATH="$PATH:$1"
  esac
}

for p in `find $HOME/opt -type d | grep bin`; do
    addToPATH $p
done

addToPATH $HOME/dotfiles/bin
addToPATH $HOME/.cargo/bin

# alias
alias ls='ls --color'
alias palette='for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 180 -s "  "; echo -e "\e[m"'
alias pwd='pwd -P'
alias vimdiff='nvim -d'
alias ipdb='python -m ipdb'
alias icat='kitty +kitten icat'
alias gps='git push'
alias gpl='git pull'
alias gst='git status'
alias glg='git log'
alias gbr='git branch'
alias gck='git checkout'
alias gdf='git diff'
alias gad='git add -u'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gro='git rebase --onto'
alias gprun='cuthon --'
alias cprun='cuthon -n 0 --'

if [ "$(uname 2> /dev/null)" = "Darwin" ]; then
    alias ls='ls -G'
fi
alias nsh='nvim +terminal +startinsert'
iv(){
    ls "$@" | sort -V | sxiv -i
}

export EDITOR='nvr -s --remote-tab-wait +"setlocal bufhidden=wipe | tabmove -1"'
export GIT_EDITOR='nvr -s --remote-tab-wait +"setlocal bufhidden=wipe | tabmove -1"'
export TERMINAL="xterm"
export GOPATH=$HOME/opt/go
export XDG_CONFIG_HOME=$HOME/.config

# pyenv
if [ -d $HOME/.pyenv ];then
    addToPATH $HOME/.pyenv/bin
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=0
fi

setupvirtualenv(){
    pip install -r $HOME/dotfiles/pyenv_default_packages
    pip install neovim-remote
}

# nvim
MANPAGER="nvim -c 'set ft=man' -"

# nvim remote
nvrte(){
    nvr --nostart --remote-expr "bufnr('%')"
    if [[ $? -eq 1 ]]; then
        nvim $@
    elif [[ $1 == /* ]]; then
        nvr -s --remote-send "<c-\><c-n>:Tabdrop $1<cr>"
    else
        nvr -s --remote-send "<c-\><c-n>:Tabdrop `pwd`/$1<cr>"
    fi
}

nvre(){
    cur_buf_num=`nvr --nostart --remote-expr "bufnr('%')"`
    if [[ $? -eq 1 ]]; then
        nvim $@
    elif [[ $1 == /* ]]; then
        nvr -s --remote-send "<c-\><c-n>:edit $1<cr> | :bw! $cur_buf_num<cr>"
    else
        nvr -s --remote-send "<c-\><c-n>:edit `pwd`/$1<cr> | :bw! $cur_buf_num<cr>"
    fi
}

alias te='nvrte'
alias e='nvre'
# dtach
dt(){
dtach -A /tmp/$1 -r winch nvim .
}

# fzf
addToPATH $HOME/.fzf/bin
MANPAGER="nvim -c 'set ft=man' -"
export FZF_DEFAULT_OPTS="--color --reverse --bind 'ctrl-s:jump,ctrl-f:page-down,ctrl-b:page-up,ctrl-y:execute-silent(echo {} | xclip -sel clip)+abort'"
unalias z 2> /dev/null

# tmux
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
