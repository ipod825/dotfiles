##ANTIGEN
GEN_HOME=$HOME/.zgen
if ! [[ -d $GEN_HOME ]]
then
    git clone https://github.com/tarjoilija/zgen.git $GEN_HOME
fi
source "$GEN_HOME/zgen.zsh"
if ! zgen saved; then
    echo "Creating a zgen save"
    zgen load Aloxaf/fzf-tab
    zgen load tarruda/zsh-autosuggestions
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load wfxr/forgit
    zgen save
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.profile

#completion
# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input
# (experimental, may change in the future)
# some boilerplate code to define the variable `extract` which will be used later
# please remember to copy them
local extract="
# trim input(what you select)
local in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
# get ctxt for current completion(some thing before or after the current word)
local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
# real path
local realpath=\${ctxt[IPREFIX]}\${ctxt[hpre]}\$in
realpath=\${(Qe)~realpath}
"

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# give a preview of directory by exa when completing cd
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'ls -1 --color=always $realpath'
compinit

##OPTIONS
#General
autoload -U zmv
WORDCHARS=${WORDCHARS/\/} #treat \ as word

#alias
alias mmv='noglob zmv -W'

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
