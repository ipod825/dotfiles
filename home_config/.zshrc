##ANTIGEN
GEN_HOME=$HOME/.zgen
if ! [[ -d $GEN_HOME ]]
then
    git clone https://github.com/tarjoilija/zgen.git $GEN_HOME
fi
source "$GEN_HOME/zgen.zsh"
if ! zgen saved; then
    echo "Creating a zgen save"
    zgen load tarruda/zsh-autosuggestions
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load wfxr/forgit
    zgen save
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.profile

##OPTIONS
#General
autoload -U zmv
WORDCHARS=${WORDCHARS/\/} #treat \ as word

#alias
alias mmv='noglob zmv -W'

#completion
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
if test `find ~/.zcompdump -mtime 1 2> /dev/null`; then
    compinit
else
    compinit -C
fi;

#history
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt HIST_NO_STORE #history does not store history command
setopt APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS  HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY # Save the time and how long a command ran

# key bindings
bindkey -v
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[D" backward-char
bindkey "^[[C" forward-char
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
bindkey "^h" backward-char
bindkey "^l" forward-char
bindkey '^r' history-incremental-search-backward
bindkey "^[h" beginning-of-line
bindkey "^[l" end-of-line
bindkey "^[d" kill-word
bindkey "^[w" backward-kill-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey 'JK' vi-cmd-mode
bindkey "^[c" cheat

RPS1="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_branch)"
    zle reset-prompt
}

function git_branch() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ $branch == "" ]]; then
        :
    else
        echo  $branch
    fi
}

function cheat { LBUFFER=`cat $HOME/dotfiles/misc/cheatsheet | fzf --no-sort --exact`
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N cheat

# PS1
host_prompt="%F{39}%m"
set_ps1() {
    sedcmd="s/\/\home\/$USER/~/g"
    directory_prompt=":%F{111}"`pwd | sed $sedcmd | sed "s:\([^/]\)[^/]*/:\1/:g"`
    PS1="$VI_MODE$host_prompt $directory_prompt "
}
chpwd_functions+=( set_ps1 )
set_ps1

#Plugins
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-char forward-word)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
ZSH_HIGHLIGHT_STYLES[globbing]=fg=11
