" .nvimrc of ipod825

let g:vim_dir=fnamemodify($MYVIMRC, ":h")."/"
exec 'source '.g:vim_dir.'common_functions.vim'
exec 'source '.g:vim_dir.'mapping.vim'
exec 'source '.g:vim_dir.'util.vim'
exec 'source '.g:vim_dir.'plugin.vim'
try
    exec 'source '.g:vim_dir.'gwork.vim'
    exec 'source '.g:vim_dir.'android.vim'
    exec 'source '.g:vim_dir.'g4.vim'
catch
endtry

" settings {{{
filetype on             " Enable filetype detection
filetype indent on      " Enable filetype-specific indenting
filetype plugin on      " Enable filetype-specific plugins
set hidden              " Enable you to edit other buffer without saving current buffer
set mouse=              " Disable mouse (for using mouse to copy text from to system clipboard)
set incsearch
set copyindent          " Copy the previous indentation on autoindenting
set smartindent
set ignorecase          " Ignore case when searching
set smartcase           " Ignore case when searching only if searching pattern contains only lower letters
set foldmethod=syntax
set foldnestmax=3       " Maximum folding
set foldtext=MyFoldText() " Show first line when folding
set wildignore=*/.git/*,*.o,*.class,*.pyc,*.aux,*.fls,*.pdf,*.fdb_latexmk "ignore these files while expanding wild chars
set splitright          " vertical split creates new buffer at right
set splitbelow          " horizontal split creates new buffer at bottom
set autoread
set timeoutlen=500
set ttimeoutlen=0
set diffopt+=vertical
set virtualedit=block
set showmatch           " Highlight matching ) and }
set cursorline
set winminwidth=0
set shiftwidth=4
set tabstop=4
set expandtab
set completeopt=menuone,noinsert
set termguicolors
set background=dark
set scrolloff=2
set lazyredraw
set noswapfile
set nobackup
set noshowmode
syntax on


if has('nvim')
    let s:pyenv_neovim2_dir=expand('~/.pyenv/versions/neovim2/bin/python')
    let s:pyenv_neovim3_dir=expand('~/.pyenv/versions/neovim3/bin/python')
    if filereadable(s:pyenv_neovim2_dir)
        let g:python_host_prog = s:pyenv_neovim2_dir
    endif
    if filereadable(s:pyenv_neovim3_dir)
        let g:python3_host_prog = s:pyenv_neovim3_dir
    endif

    set inccommand=split
    set shada=!,'1000,<50,s10,h
endif
" }}}

augroup GENERAL "{{{
    autocmd!
    " auto reload vimrc
    autocmd BufWritePost $MYVIMRC,*.vim source %:p | call VimRcWrite()
    autocmd BufAdd $MYVIMRC,*.vim setlocal foldmethod=marker

    " Diff setting
    autocmd BufWritePost * if &diff == 1 | diffupdate | endif
    autocmd OptionSet diff setlocal wrap

    " Terminal
    let s:auto_term_insert=1
    command! ToggleTermInsert execute "let s:auto_term_insert=1-s:auto_term_insert"
    if has('nvim')
        autocmd TermOpen * setlocal wrap
        autocmd TermOpen * setlocal nobuflisted
        autocmd TermOpen * autocmd BufEnter <buffer> if s:auto_term_insert | startinsert | endif
        autocmd TextYankPost * lua vim.highlight.on_yank {higroup='IncSearch', timeout=200}
    else
        autocmd TerminalOpen * setlocal wrap
    endif

    " Automatically change directory (avoid vim-fugitive)
    autocmd BufEnter * if &ft != 'gitcommit' | silent! lcd %:p:h | endif

    " Man in new tab
    autocmd FileType man wincmd T

    " Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " Move to last position and unfold when openning a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | exe "normal! zi" | endif

    " Writing
    autocmd BufEnter *.tex,*.md,*.adoc setlocal spell
    autocmd BufEnter *.tex setlocal nocursorline
    autocmd BufEnter *.tex setlocal wildignore+=*.aux,*.fls,*.blg,*.pdf,*.log,*.out,*.bbl,*.fdb_latexmk
    autocmd BufEnter *.md,*.tex inoremap <buffer> sl \
    autocmd BufEnter *.md,*.tex inoreabbrev <buffer> an &
    autocmd BufEnter *.md,*.tex inoreabbrev <buffer> da $$<Left>
    autocmd BufEnter *.md,*.tex inoreabbrev <buffer> pl +
    autocmd BufEnter *.md,*.tex inoreabbrev <buffer> mi -
    autocmd BufEnter *.md,*.tex inoreabbrev <buffer> eq =
    autocmd BufEnter *.md,*.tex inoremap <buffer> <M-j> _
    autocmd BufEnter *.md,*.tex inoremap <buffer> <M-j> _
    autocmd BufEnter *.md,*.tex inoremap <buffer> <M-k> ^
    autocmd BufEnter *.md,*.tex inoremap <buffer> <M-q> {}<Left>

    " Set correct filetype.
    autocmd BufEnter *sxhkdrc* setlocal ft=sxhkdrc | setlocal commentstring=#%s | setlocal foldmethod=marker
    autocmd BufEnter *.xinitrc setlocal ft=sh | setlocal commentstring=#%s

    " Reload on write.
    autocmd BufWritePost *sxhkdrc* silent !pkill -USR1 sxhkd
    autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

    autocmd Filetype qf nnoremap <buffer> <cr> :call QfCr()<cr>
augroup END
" }}}

function! QfCr()
    if winnr('$') > 2
        exec "normal! \<c-w>w"
    else
        execute "normal! \<c-w>o\<cr>"
    endif
endfunction

" functions {{{
function! SetColorScheme(...)
try
    set termguicolors
    execute 'colorscheme '.g:my_colorscheme
catch
endtry
endfunction
function! VimRcWrite()
    setlocal foldmethod=marker
    setlocal commentstring=\"%s
    call timer_start(10, function('SetColorScheme'))
endfunction
call SetColorScheme()

function! MyFoldText()
    let nucolwidth = &fdc + &number*&numberwidth
    let winwd = winwidth(0) - nucolwidth - 5
    let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
    let prefix = " _______>>> "
    let fdnfo = prefix . string(v:foldlevel) . "," . string(foldlinecount)
    let line =  strpart(getline(v:foldstart), 0 , winwd - len(fdnfo))
    let fillcharcount = winwd - len(line) - len(fdnfo)
    return line . repeat(" ",fillcharcount) . fdnfo
endfunction
" }}}
