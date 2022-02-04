function prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then return lib end
    -- Library failed to load, so perhaps return `nil` or something?
    return nil
end

vim.cmd('colorscheme main')
require('utils')
require('mapping')
require('vplug')
require('plugins')
require('tabline')
require('fzf_cfg')
require('qf')
require('lsp')
require('profile')
prequire('gwork')
prequire('android')
prequire('g4')

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
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data') .. '/undo'
vim.o.switchbuf = 'usetab'
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

require'Vim'.augroup('GENERAL', {
    -- auto reload vimrc
    [[BufWritePost $MYVIMRC,*.vim source %:p]],
    [[BufAdd $MYVIMRC,*.vim setlocal foldmethod=marker]],

    -- Diff setting
    [[BufWritePost * if &diff == 1 | diffupdate | endif]],

    [[OptionSet diff setlocal wrap | nmap <buffer> <c-j> ]c | nmap <buffer> <c-k> [c | nmap <buffer> q <cmd>tabclose<cr>]],
    [[TextYankPost * lua vim.highlight.on_yank {higroup='IncSearch', timeout=200}]] -- Automatically change directory (avoid vim-fugitive)
    ,
    [[BufEnter * if &ft != 'gitcommit' && &ft != 'qf' | silent! lcd %:p:h | endif]],

    -- Automatically reload plugin.lua on write.
    [[BufWritePost plugin.lua source <afile>]],

    -- Man/help in left new tab
    [[FileType man wincmd T | silent! tabmove -1]],

    [[FileType help silent! tabmove -1 | setlocal bufhidden=wipe ]] -- Disables automatic commenting on newline:
    ,
    [[FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]] -- Move to last position and unfold when openning a file
    ,
    [[BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | exe "normal! zi" | endif]],

    -- Writing
    [[BufEnter *.tex,*.md,*.adoc setlocal spell]],
    [[BufEnter *.tex setlocal nocursorline]],

    [[BufEnter *.tex setlocal wildignore+=*.aux,*.fls,*.blg,*.pdf,*.log,*.out,*.bbl,*.fdb_latexmk]],
    [[BufEnter *.md,*.tex inoremap <buffer> sl \]],
    [[BufEnter *.md,*.tex inoreabbrev <buffer> an &]],
    [[BufEnter *.md,*.tex inoreabbrev <buffer> da $$<Left>]],
    [[BufEnter *.md,*.tex inoreabbrev <buffer> pl +]],
    [[BufEnter *.md,*.tex inoreabbrev <buffer> mi -]],
    [[BufEnter *.md,*.tex inoreabbrev <buffer> eq =]],
    [[BufEnter *.md,*.tex inoremap <buffer> <M-j> _]],
    [[BufEnter *.md,*.tex inoremap <buffer> <M-j> _]],
    [[BufEnter *.md,*.tex inoremap <buffer> <M-k> ^]],
    [[BufEnter *.md,*.tex inoremap <buffer> <M-q> {}<Left>]],

    -- Comment
    [[Filetype c,cpp setlocal commentstring=//\ %s]],

    -- Set correct filetype.

    [[BufEnter *sxhkdrc* setlocal ft=sxhkdrc | setlocal commentstring=#%s | setlocal foldmethod=marker]],
    [[BufEnter *.xinitrc setlocal ft=sh | setlocal commentstring=#%s]],

    -- Reload on write.
    [[BufWritePost *sxhkdrc* silent !pkill -USR1 sxhkd]],
    [[BufWritePost *Xresources,*Xdefaults !xrdb %]]
})
