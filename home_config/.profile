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

for p in `find $HOME/.local -type d | grep bin`; do
    addToPATH $p
done

addToPATH $HOME/dotfiles/bin
addToPATH $HOME/.cargo/bin

source bashlib

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
alias gdf='git difftool --no-symlinks --dir-diff'
alias gad='git add -u'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gro='git rebase --onto'
alias hlg='hg xl'
alias hst='hg status'
alias hpl='hg sync'
alias hdf='hg diff'
alias hps='hg upload tree'
alias gprun='cuthon --'
alias cprun='cuthon -n 0 --'
alias hi='notify-send -u critical -t 5000 "Job Finished" `printf "~%.0s" {1..100}`'

if [ "$(uname 2> /dev/null)" = "Darwin" ]; then
    alias ls='ls -G'
fi
alias nsh='nvim +terminal +startinsert'
iv(){
    ls "$@" | sort -V | sxiv -i
}

export EDITOR='nvr -s --remote-tab-wait +"setlocal bufhidden=wipe | silent! tabmove -1"'
export GIT_EDITOR=$EDITOR
export TERMINAL="alacritty"
export GOPATH=$HOME/opt/go
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

# pyenv (lazily loaded by davidparsson/zsh-pyenv-lazy)
if [ -d $HOME/.pyenv ];then
    addToPATH $HOME/.pyenv/bin
    export PYENV_VIRTUALENV_DISABLE_PROMPT=0
fi

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
addToPATH $HOME/.local/share/nvim/site/pluggins/fzf/bin
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
