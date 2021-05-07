require('utils')
require('mapping')
require('tabline')
require('plugin')
require('fzf_cfg')
require('gwork')
require('android')
require('g4')

function _G.p(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

vim.o.syntax = 'on'
vim.o.filetype = 'on'
vim.g.mapleader = ' '
vim.o.hidden = true
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.wildignore =
    [[*/.git/*,*.o,*.class,*.pyc,*.aux,*.fls,*.pdf,*.fdb_latexmk]]
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.background = 'dark'
vim.o.autoread = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0
vim.o.diffopt = vim.o.diffopt .. ',vertical'
vim.o.virtualedit = 'block'
vim.o.showmatch = true
vim.o.cursorline = true
vim.o.winminwidth = 0
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.scrolloff = 2
vim.o.lazyredraw = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.showmode = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data') .. '/undo'
vim.api.nvim_exec([[
    set copyindent
    set smartindent
    set smartcase
    set cursorline
    set winminwidth=0
    set shiftwidth=4
    set tabstop=4
    set expandtab
    set scrolloff=2
    set noswapfile
    set nobackup
    set undofile
]], false)

vim.api.nvim_exec([[

augroup GENERAL "{{{
    autocmd!
    " auto reload vimrc
    autocmd BufWritePost $MYVIMRC,*.vim source %:p
    autocmd BufAdd $MYVIMRC,*.vim setlocal foldmethod=marker

    " Diff setting
    autocmd BufWritePost * if &diff == 1 | diffupdate | endif
    autocmd OptionSet diff setlocal wrap | nmap <buffer> <c-j> ]c | nmap <buffer> <c-k> [c | nmap <buffer> q <cmd>tabclose<cr>

    autocmd TextYankPost * lua vim.highlight.on_yank {higroup='IncSearch', timeout=200}

    " Automatically change directory (avoid vim-fugitive)
    autocmd BufEnter * if &ft != 'gitcommit' | silent! lcd %:p:h | endif

    " Man/help in left new tab
    autocmd FileType man wincmd T | silent! tabmove -1

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

    " Comment
    autocmd Filetype c,cpp setlocal commentstring=//\ %s

    " Set correct filetype.
    autocmd BufEnter *sxhkdrc* setlocal ft=sxhkdrc | setlocal commentstring=#%s | setlocal foldmethod=marker
    autocmd BufEnter *.xinitrc setlocal ft=sh | setlocal commentstring=#%s

    " Reload on write.
    autocmd BufWritePost *sxhkdrc* silent !pkill -USR1 sxhkd
    autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

augroup END
]], false)
