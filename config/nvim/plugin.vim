" Download vim-plug
let vim_plug_file=expand(g:vim_dir . 'autoload/plug.vim')
if !filereadable(vim_plug_file)
    echo "Installing vim-plug.."
    echo ""
    execute 'silent !mkdir -p ' . g:vim_dir . 'autoload'
    call system('curl -fLo '.g:vim_dir.'autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
endif

call plug#begin(g:vim_dir . 'bundle')
Plug 'junegunn/vim-plug'
Plug 'simnalamburt/vim-mundo' "{{{
execute "set undodir=".g:vim_dir."undo/"
let g:mundo_width = float2nr(0.2 * &columns)
let g:mundo_preview_height = float2nr(0.5 * &lines)
let g:mundo_right = 1
let mundo_preview_bottom = 1
set undofile
augroup MUNDO
    autocmd!
    autocmd Filetype MundoDiff set wrap
augroup END
""}}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' "{{{
autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
autocmd VimEnter * command! -bang -nargs=? Buffers call fzf#vim#buffers(<q-args>, {'options': '--no-preview'}, <bang>0)
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.95 } }
let $FZF_DEFAULT_COMMAND = 'find .'
let g:fzf_action = { 'ctrl-e': 'edit', 'Enter': 'Tabdrop', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }
"}}}

Plug 'git@github.com:ipod825/vim-tabdrop'

Plug 'rakr/vim-one' "{{{
augrou ONE
    autocmd!
    autocmd ColorScheme * call one#highlight("CursorLine", '', '2e5057', 'bold')
    autocmd ColorScheme * call one#highlight("Visual", '', '2e5057', '')
    autocmd ColorScheme * call one#highlight("Comment", '7c7d7d', '', '')
augrou END
"}}}

Plug 'tpope/vim-commentary' "{{{
nmap <c-_> gcc
vmap <c-_> gc
augroup COMMENTARY
    autocmd Filetype c,cpp setlocal commentstring=//\ %s
augroup END
"}}}

if has('nvim')
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
endif

Plug 'Yggdroot/indentLine' "{{{
let g:indentLine_concealcursor='nvc'
"}}}

Plug 'tpope/vim-scriptease'
Plug 'vim-scripts/gtags.vim'
Plug 'wsdjeg/vim-fetch'

Plug 'jreybert/vimagit', {'on_cmd': 'Magit'} "{{{
augroup MAGIT
    autocmd!
    autocmd Filetype magit wincmd T
augrou END
"}}}
Plug 'rhysd/git-messenger.vim' "{{{
"}}}

Plug 'lambdalisue/gina.vim' "{{{
cnoreabbrev G Gina status -s
cnoreabbrev gbr Gina branch +tabmove\ -1
cnoreabbrev glg Gina log --branches --graph
cnoreabbrev glc exec "Gina log --branches --graph -- ".expand("%:p")
cnoreabbrev gps Gina push
cnoreabbrev gpl Gina pull
cnoreabbrev grc Gina rebase --continue
augroup GINA
    autocmd!
    autocmd USER PLUG_END call s:SetupGina()
augroup END

function! s:SetupGina()
	call gina#custom#command#option('/\%(status\|commit\)', '--opener', 'botright split')
	call gina#custom#command#option('/\%(branch\|log\)', '--opener', 'tabedit')
	call gina#custom#command#option('/\%(changes\)', '--opener', 'vsplit')
	call gina#custom#mapping#nmap('/.*', '<F1>','<Plug>(gina-builtin-help)')
    call gina#custom#mapping#nmap('/.*', '?','<Plug>MSAddBySearchForward')
	call gina#custom#mapping#nmap('status', '<cr>','<Plug>(gina-edit-tab)')
	call gina#custom#mapping#nmap('status', '-','<Plug>(gina-index-toggle)j', {'nowait': v:true})
	call gina#custom#mapping#vmap('status', '-','<Plug>(gina-index-toggle)', {'nowait': v:true})
	call gina#custom#mapping#nmap('status', 'X','<Plug>(gina-index-discard-force)')
	call gina#custom#mapping#vmap('status', 'X','<Plug>(gina-index-discard-force)')
	call gina#custom#mapping#nmap('status', 'H','<Plug>(gina-index-stage)j')
	call gina#custom#mapping#vmap('status', 'H','<Plug>(gina-index-stage)')
	call gina#custom#mapping#nmap('status', 'L','<Plug>(gina-index-unstage)j')
	call gina#custom#mapping#vmap('status', 'L','<Plug>(gina-index-unstage)')
	call gina#custom#mapping#nmap('status', 'dd','<Plug>(gina-diff-vsplit)')
	call gina#custom#mapping#nmap('status', 'DD','<Plug>(gina-compare-vsplit)')
	call gina#custom#mapping#nmap('status', 'cc',':quit<cr>:Gina commit<CR>')
	call gina#custom#mapping#nmap('status', 'ca',':quit<cr>:Gina commit --amend --allow-empty<CR>')
    call gina#custom#mapping#nmap('log', '<cr>','<Plug>(gina-show-vsplit)')
    call gina#custom#mapping#nmap('log', 'dd','<Plug>(gina-show-vsplit)')
    call gina#custom#mapping#nmap('log', 'DD','<Plug>(gina-changes-between)')
    call gina#custom#mapping#nmap('log', '<m-w>',':set wrap!<cr>')
    call gina#custom#mapping#nmap('log', 'cc',':call GinaLogCheckout()<cr>')
    call gina#custom#mapping#nmap('log', 'cb',':call GinaLogCheckoutNewBranch()<cr>')
    call gina#custom#mapping#nmap('log', 'rs',':call GinaLogReset(''--soft'')<cr>')
    call gina#custom#mapping#nmap('log', 'rm',':call GinaLogReset(''--mixed'')<cr>')
    call gina#custom#mapping#nmap('log', 'rh',':call GinaLogReset(''--hard'')<cr>')
    call gina#custom#mapping#nmap('log', 'R',':call GinaLogRebase()<cr>')
    call gina#custom#mapping#nmap('changes', '<cr>','<Plug>(gina-diff-tab)')
    call gina#custom#mapping#nmap('changes', 'dd','<Plug>(gina-diff-vsplit)')
    call gina#custom#mapping#nmap('changes', 'DD','<Plug>(gina-compare-vsplit)')
    call gina#custom#mapping#nmap('branch', '<m-n>','<Plug>(gina-branch-new)')
    call gina#custom#mapping#nmap('branch', '<m-d>','<Plug>(gina-branch-delete)')
    call gina#custom#mapping#nmap('branch', '<m-s-d>','<Plug>(gina-branch-delete-force)')
    call gina#custom#mapping#nmap('branch', '<m-m>','<Plug>(gina-branch-move)')
    call gina#custom#mapping#nmap('branch', 'T','<Plug>(gina-branch-set-upstream-to)')
    call gina#custom#mapping#nmap('branch', 'dd','<Plug>(gina-show-commit-vsplit)')
    call gina#custom#mapping#nmap('branch', 'DD','<Plug>(gina-changes-between)')
    call gina#custom#mapping#nmap('branch', 'R','<Plug>(gina-commit-rebase)')
endfunction

function! GitInfo() abort
    let br = gina#component#repo#branch()
    if br=~ '[0-9a-f]\{40\}'
        let br = br[:5]
    endif
    let br = empty(br)?'':"⎇ ".br
    return br
    " let ah = gina#component#traffic#ahead()
    " let bh =  gina#component#traffic#behind()
    " let ah = ah!=0?'↑'.ah:''
    " let bh = bh!=0?'↓'.bh:''
    " return br.ah.bh
endfunction

function! s:BranchFilter(k, v)
    if a:v=='HEAD'
        return
    elseif a:v=~ 'HEAD ->'
        return a:v[8:]
    else
        return a:v
    endif
endfunction

function! s:GinaLogCandidate()
    let l:cand = [matchstr(getline('.'), '[0-9a-f]\{6,9\}')]
    let l:branches = matchstr(getline('.'), '([^)]*)')
    if !empty(l:branches)
        let l:branches = l:branches[1:len(l:branches)-2]
        call extend(l:cand, split(l:branches, ','))
        let l:cand = map(l:cand, function('<sid>BranchFilter'))
    endif
    return l:cand
endfunction

function! s:GinaLogCheckoutPost(branch, ...)
    let l:args=a:0>0?a:1:''
    exec '!git checkout '.a:branch.' '.l:args
    Gina log --branches  --graph --opener=edit
endfunction

function! GinaLogCheckout()
    let l:cand = s:GinaLogCandidate()
    echom l:cand
    if len(l:cand)>1
        call fzf#run(fzf#wrap({
                \ 'source': sort(l:cand),
                \ 'sink': function('s:GinaLogCheckoutPost'),
            \}))
    else
        call s:GinaLogCheckoutPost(l:cand[0])
    endif
endfunction

function! GinaLogCheckoutNewBranch()
    let l:cand = s:GinaLogCandidate()
    let l:nb = input('New branch name: ')
    call s:GinaLogCheckoutPost(l:cand[0], '-b '.l:nb)
endfunction

function! GinaLogRebase()
    let l:cand = s:GinaLogCandidate()
    exec 'Gina!! rebase -i '.l:cand[0]
endfunction

function! GinaLogReset(opt)
    let l:cand = s:GinaLogCandidate()
    exec 'Gina reset 'a:opt.' '.l:cand[0]
endfunction
"}}}


Plug 'itchyny/lightline.vim' "{{{
let g:asyncrun_status=get(g:,'asyncrun_status',"success")
let g:lightline = {
            \ 'colorscheme': 'wombat' ,
            \ 'active': {
            \   'left': [['mode', 'paste'],
            \            ['readonly', 'filename'],
            \            ],
            \   'right': [['lineinfo'],
            \              ['percent'],
            \              ['gitinfo'],['asyncrun']]
            \  },
            \ 'inactive': {
            \   'left': [['filename'],
            \            ],
            \   'right': [['lineinfo'],
            \              ['percent'],
            \               ]},
            \ 'component': {
            \         'gitinfo': '%{GitInfo()}',
            \         'asyncrun': '%{g:asyncrun_status=="running"?g:asyncrun_status:""}',
            \         'fugitiveobj': '%{FugitiveObj()}'
            \ },
            \ }
let g:lightline.tab = {
		    \ 'active': [ 'modified', 'filename' ],
		    \ 'inactive': [ 'modified', 'filename' ] }
"}}}

Plug 'git@github.com:ipod825/msearch.vim'
nmap 8 <Plug>MSToggleAddCword
vmap 8 <Plug>MSToggleAddVisual
nmap * <Plug>MSExclusiveAddCword
vmap * <Plug>MSExclusiveAddVisual
nmap n <Plug>MSNext
nmap N <Plug>MSPrev
omap n <Plug>MSNext
omap N <Plug>MSPrev
nmap <leader>n <Plug>MSToggleJump
nmap <leader>/ <Plug>MSClear
nmap ? <Plug>MSAddBySearchForward
function! s:SelectAllMark()
    call feedkeys("\<Plug>(VM-Start-Regex-Search)".join(msearch#joint_pattern())."\<cr>")
    call feedkeys("\<Plug>(VM-Select-All)")
endfunction
nmap <leader>r :call <sid>SelectAllMark()<cr>

Plug 'fatih/vim-go', {'for': 'go'}
Plug 'voldikss/vim-translator', {'on': 'TranslateW'} "{{{
"}}}

Plug 'jiangmiao/auto-pairs' "{{{
inoremap <m-e> <esc>:call <sid>AutoPairsJump()<cr>
let g:AutoPairsShortcutFastWrap = '<nop>'
let g:AutoPairsMapCh = '<nop>'
let g:AutoPairsShortcutToggle = '<nop>'
let g:AutoPairsShortcutJump = '<nop>'
let g:AutoPairsDelete = '<nop>'
let g:AutoPairsMultilineClose = 0
augroup AUTO_PAIRS
    autocmd!
    autocmd BufEnter *.tex,*.md,*.adoc let g:AutoPairs["$"] = "$"
    autocmd BufLeave *.tex,*.md,*.adoc unlet g:AutoPairs["$"]
    autocmd BufEnter *.scm unlet g:AutoPairs["'"]
    autocmd BufLeave *.scm let g:AutoPairs["'"] = "'"
augroup End
function! s:AutoPairsJump()
    call feedkeys('l')
    let l:b = getline('.')[col('.')+1]
    call feedkeys('dl')
    if match(l:b, "[\"' ]")  == -1
        call feedkeys('e')
    endif
    call feedkeys('pi')
endfunction
" }}}

Plug 'skywind3000/asyncrun.vim' "{{{
augroup ASYNCRUN
    autocmd!
    autocmd User AsyncRunStop if g:asyncrun_code!=0 | copen | wincmd T | endif
augroup END
"}}}
Plug 'tpope/vim-endwise'
Plug 'mg979/vim-visual-multi' "{{{
let g:VM_default_mappings = 0
let g:VM_reselect_first = 1
let g:VM_notify_previously_selected = 1
let g:VM_theme = 'iceblue'
let g:VM_maps = {}
let g:VM_maps["Switch Mode"] = 'v'
let g:VM_maps['Find Word'] = '<C-n>'
let g:VM_maps['Skip Region'] = '<C-x>'
let g:VM_maps['Remove Region'] = '<C-p>'
let g:VM_maps['Goto Prev'] = '<c-k>'
let g:VM_maps['Goto Next'] = '<c-j>'
let g:VM_maps["Undo"] = 'u'
let g:VM_maps["Redo"] = '<c-r>'
let g:VM_maps["Numbers"] = '<leader>n'
let g:VM_maps["Visual Add"] = '<C-n>'
let g:VM_maps["Visual Find"] = '<C-n>'
let g:VM_maps["Visual Regex"] = '<leader>/'
let g:VM_maps["Visual Cursors"] = '<C-c>'
let g:VM_custom_noremaps  = {'])': '])', ']]': ']]', ']}':']}',
            \'<M-l>': 'g$', '<M-h>': 'g^'}
fun! VM_Start()
    autocmd! VIM-MARK
    imap <buffer> jk <Esc>
    imap <buffer> <c-h> <Left>
    imap <buffer> <c-l> <Right>
    imap <buffer> <c-j> <Down>
    imap <buffer> <c-k> <Up>
    imap <buffer> <m-h> <Esc>g^i
    imap <buffer> <m-l> <Esc>g_i
    nmap <buffer> <c-c> <esc>
    vmap <buffer> <m-l> $
    vmap <buffer> <m-h> 0
endfun
function! s:SelectAllMark()
    call feedkeys("\<Plug>(VM-Start-Regex-Search)".msearch#joint_pattern()."\<cr>")
    call feedkeys("\<Plug>(VM-Select-All)")
endfunction
nmap <leader>r :call <sid>SelectAllMark()<cr>

Plug 't9md/vim-textmanip' "{{{
xmap <c-m-k> <Plug>(textmanip-move-up)
xmap <c-m-h> <Plug>(textmanip-move-left)
xmap <c-m-l> <Plug>(textmanip-move-right)
xmap <c-m-j> <Plug>(textmanip-move-down)
" shift in visual mode
nmap <nowait> < V<Plug>(textmanip-move-left)<esc>
nmap <nowait> > V<Plug>(textmanip-move-right)<esc>
vmap <nowait> < <Plug>(textmanip-move-left)
vmap <nowait> > <Plug>(textmanip-move-right)
"}}}

Plug 'git@github.com:ipod825/julia-unicode.vim', {'for': 'julia'}
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } " align code - helpful for latex table  {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh;'} "{{{
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI="quickfix"
let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_hoverPreview="Always"
let g:LanguageClient_settingsPath=g:vim_dir."settings/lsp.json"
let g:LanguageClient_serverCommands = {
            \ 'python': ['pyls'],
            \ 'zsh': ['shellcheck'],
            \ 'cpp': ['clangd'],
            \ 'c': ['clangd'],
            \ 'go': ['gopls']
            \ }
function! s:Gotodef()
    TabdropPushTag
    try
        TagTabdrop
    catch /E433:\|E426:/
        call LanguageClient_textDocument_definition({'gotoCmd': 'Tabdrop'})
    endtry
endfunction
nnoremap <m-d> :call <sid>Gotodef()<cr>
nmap <m-s> :TabdropPopTag<cr><esc>
nnoremap <silent> LH :call LanguageClient#textDocument_hover()<cr>
nnoremap <silent> LC :call LanguageClient_contextMenu()<cr>
let g:LanguageClient_selectionUI='fzf'
" function! s:AsyncFormat()
"     let g:lsp_is_formatting = get(g:, 'lsp_is_formatting', v:false)
"     if g:lsp_is_formatting
"         return
"     endif
"     let g:lsp_is_formatting = v:true
"     call LanguageClient#textDocument_formatting({}, {-> execute('write | let g:lsp_is_formatting=v:false', "")})
" endfunction
" augroup LANGUAGECLIENTNEOVIM
"     autocmd!
"     autocmd BufWritePre * call s:AsyncFormat()
" augroup END
"}}}

Plug 'w0rp/ale' " {{{ (only used for the more flexxible formatter)
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_lint_on_save = 0
let g:ale_lint_on_text_changed = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_enabled = 0
let g:ale_virtualtext_cursor=1
let g:ale_completion_enabled=0
let g:ale_fix_on_save = 1
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'python': ['yapf', 'isort'],
            \'cpp': ['clang-format']
            \}
"}}}


if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif "{{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 0
if !exists('g:deoplete#omni_patterns')
    let g:deoplete#omni_patterns = {}
endif
"}}}

Plug 'lervag/vimtex', {'for': 'tex'} "{{{
let g:tex_flavor = 'latex'
let g:vimtex_fold_enabled = 1
let g:polyglot_disabled = ['latex']
let g:vimtex_log_ignore=['25']
let g:vimtex_view_general_viewer = 'zathura'
augroup VIMTEX
    autocmd!
    if &rtp =~ 'deoplete.nvim'
        " call deoplete#custom#var('omni', 'input_patterns', {
        "             \ 'tex': g:vimtex#re#deoplete
        "             \})
        augroup VIMTEX
            autocmd!
            autocmd Filetype tex call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
        augroup END
    endif
augroup END

let g:tex_conceal="abdgm"
highlight Conceal term=bold cterm=bold ctermbg=236
highlight Conceal cterm=bold ctermfg=255 ctermbg=233
highlight Conceal term=bold cterm=bold ctermbg=red
highlight Conceal cterm=bold ctermfg=255 ctermbg=red
"}}}

Plug 'airblade/vim-rooter' "{{{
let g:rooter_manual_only = 1
"}}}

Plug 'sheerun/vim-polyglot' "{{{
let g:polyglot_disabled=['markdown']
"}}}

Plug 'SirVer/ultisnips' "{{{
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetDirectories=[g:vim_dir.'UltiSnips']
"}}}

Plug 'rhysd/vim-grammarous', {'on': 'GrammarousCheck'}

packadd termdebug "{{{
command! Debug execute 'call <sid>Debug()'
command!  -nargs=* DebugGo call <sid>DebugGo(<f-args>)
command!  -nargs=* DebugGoStop call <sid>DebugGoStop()
command!  -nargs=* Test echo <q-args>

function! Save_mappings(keys, mode, is_global) abort
    let mappings = {}
    if a:is_global
        for l:key in a:keys
            let buf_local_map = maparg(l:key, a:mode, 0, 1)
            sil! exe a:mode.'unmap <buffer> '.l:key
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                                \     ? map_info
                                \     : {
                                        \ 'unmapped' : 1,
                                        \ 'buffer'   : 0,
                                        \ 'lhs'      : l:key,
                                        \ 'mode'     : a:mode,
                                        \ }
            call Restore_mappings({l:key : buf_local_map})
        endfor
    else
        for l:key in a:keys
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                                \     ? map_info
                                \     : {
                                        \ 'unmapped' : 1,
                                        \ 'buffer'   : 1,
                                        \ 'lhs'      : l:key,
                                        \ 'mode'     : a:mode,
                                        \ }
        endfor
    endif
    return mappings
endfu

function! Restore_mappings(mappings) abort
    for [lhs, mapping] in items(a:mappings)
        if empty(mapping)
            continue
        endif
        if has_key(mapping, 'unmapped')
            sil! exe mapping.mode.'unmap '
                                \ .(mapping.buffer ? ' <buffer> ' : '')
                                \ . mapping.lhs
        else
            let rhs = mapping.rhs
            if has_key(mapping, 'sid')
                let rhs = substitute(rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')
            endif
            exe     mapping.mode
               \ . (mapping.noremap ? 'noremap   ' : 'map ')
               \ . (mapping.buffer  ? ' <buffer> ' : '')
               \ . (mapping.expr    ? ' <expr>   ' : '')
               \ . (mapping.nowait  ? ' <nowait> ' : '')
               \ . (mapping.silent  ? ' <silent> ' : '')
               \ . lhs.' '.rhs
        endif
    endfor
endfu

function! s:MapDebug()
    let g:saved_normal_mappings = Save_mappings(['n','s','c','B','C','e','f','U','D','t'], 'n', 1)
    let g:saved_visual_mappings = Save_mappings(['e'], 'x', 1)
    nnoremap n :call TermDebugSendCommand('next')<cr>
    nnoremap s :call TermDebugSendCommand('step')<cr>
    nnoremap c :call TermDebugSendCommand('continue')<cr>
    nnoremap B :Break<cr>
    nnoremap C :Clear<cr>
    nnoremap e :Evaluate<cr>
    nnoremap f :Finish<cr>
    nnoremap U :call TermDebugSendCommand('up')<cr>
    nnoremap D :call TermDebugSendCommand('down')<cr>
    nnoremap t :call TermDebugSendCommand('until '.line('.'))<cr>
    xmap e :Evaluate<cr>
endfunction

function! s:UnmapDebug()
    call Restore_mappings(g:saved_normal_mappings)
    let g:saved_normal_mappings = {}
    call Restore_mappings(g:saved_visual_mappings)
    let g:saved_visual_mappings = {}
endfunction

function! s:Debug()
    let bin=expand('%:r')
    wincmd H
    Program
    wincmd J
    resize 10
    call <sid>MapDebug()
    Gdb
    execute 'autocmd BufUnload <buffer> call <sid>UnmapDebug()'
    call feedkeys('file '.bin."\<cr>")
endfunction

function! s:GoMapDebug()
    let g:saved_normal_mappings = <sid>Save_mappings(['n','s','c','B','C','e','f','U','D','t'], 'n', 1)
    " let g:saved_visual_mappings = <sid>Save_mappings(['e'], 'x')
    nnoremap n :GoDebugNext<cr>
    nnoremap s :GoDebugStep<cr>
    nnoremap c :GoDebugContinue<cr>
    nnoremap B :GoDebugBreakpoint<cr>
    nnoremap e :GoDebugPrint<cr>
    nnoremap f :GoDebugStepOut<cr>
    " nnoremap U :call TermDebugSendCommand('up')<cr>
    " nnoremap D :call TermDebugSendCommand('down')<cr>
    " nnoremap t :call TermDebugSendCommand('until '.line('.'))<cr>
    " xmap e :Evaluate<cr>
endfunction

function! s:GoUnmapDebug()
    call Restore_mappings(g:saved_normal_mappings)
    let g:saved_normal_mappings = {}
    " call estore_mappings(g:saved_visual_mappings)
    " let g:saved_visual_mappings = {}
endfunction


function! s:DebugGo(...)
    call <sid>GoMapDebug()
    exe 'GoDebugStart '.join(a:000)
endfunction

function! s:DebugGoStop()
    call <sid>GoUnmapDebug()
    exe 'GoDebugStop'
endfunction

"}}}

Plug 'chrisbra/Recover.vim' "{{{
"}}}

Plug 'git@github.com:ipod825/war.vim' "{{{
augroup WAR
    autocmd!
    autocmd Filetype qf :call war#fire(-1, 0.7, -1, 0.3)
    autocmd Filetype fugitive :call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-status :call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-commit :call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-stash-show :call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-log :call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-branch :call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-changes :call war#fire(1, 1, 0, 0)
    autocmd Filetype git :call war#fire(-1, 0.8, -1, 0.1)
    autocmd Filetype esearch :call war#fire(0.8, -1, 0.2, -1)
    autocmd Filetype bookmark :call war#fire(-1, 1, 0.2, -1)
    autocmd Filetype bookmark :call war#enter(-1)
augroup END
" }}}

Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'sgur/vim-textobj-parameter'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'kana/vim-textobj-line'
Plug 'terryma/vim-expand-region'
Plug 'machakann/vim-textobj-functioncall'
Plug 'whatyouhide/vim-textobj-xmlattr', { 'for': ['html', 'xml'] } "{{{
vmap <m-k> <Plug>(expand_region_expand)
vmap <m-j> <Plug>(expand_region_shrink)
nmap <m-k> <Plug>(expand_region_expand)
nmap <m-j> <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
            \ 'iv' :0,
            \ 'av'  :0,
            \ 'iw'  :0,
            \ 'i"'  :0,
            \ 'a"'  :0,
            \ 'i''' :0,
            \ 'a''' :0,
            \ 'i]'  :1,
            \ 'ib'  :1,
            \ 'ab'  :1,
            \ 'iB'  :1,
            \ 'aB'  :1,
            \ 'a,'  :0,
            \ 'if'  :0,
            \ 'il'  :0,
            \ 'ip'  :0,
            \ 'ix'  :0,
            \ 'ax'  :0,
            \ }
"}}}

" Plug 'tpope/vim-abolish'
Plug 'majutsushi/tagbar' "{{{
"}}}

Plug 'git@github.com:ipod825/vim-bookmark' "{{{
nnoremap ' :BookmarkGo netranger<cr>
nnoremap <leader>m :BookmarkAddPos<cr>
nnoremap <leader>' :BookmarkGo<cr>
let g:bookmark_opencmd='NewTabdrop'
function! s:Bookmark_pos_context_fn()
    return [tagbar#currenttag("%s", "", "f"), getline('.')]
endfunction
let g:Bookmark_pos_context_fn = function('s:Bookmark_pos_context_fn')
augroup BOOKMARK
    autocmd!
    autocmd Filetype bookmark nmap <buffer> pp :call bookmark#preview('vsplit')<cr>
augroup END
" }}}

Plug 'machakann/vim-sandwich'
Plug 'justinmk/vim-sneak' "{{{
nmap S <Plug>Sneak_s
nmap gS <Plug>Sneak_S
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap H <Plug>Sneak_,
nmap L <Plug>Sneak_;
vmap H <Plug>Sneak_,
vmap L <Plug>Sneak_;
let g:sneak#absolute_dir=1
"}}}

Plug 'machakann/vim-swap'
Plug 'maxbrunsfeld/vim-yankstack' " {{{
let g:yankstack_yank_keys = ['y', 'd', 'x', 'c']
nmap <M-p> <Plug>yankstack_substitute_older_paste
nmap <M-n> <Plug>yankstack_substitute_newer_paste
"}}}

Plug 'Shougo/deol.nvim', { 'do': ':UpdateRemotePlugins' } "{{{
"}}}

Plug 'eugen0329/vim-esearch' "{{{
let g:esearch = {
            \ 'adapter':          'ag',
            \ 'bckend':          'nvim',
            \ 'out':              'win',
            \ 'batch_size':       1000,
            \ 'default_mappings': 1,
            \}
nmap <leader>f <Plug>(operator-esearch-prefill)iw
vmap <leader>f <Plug>(esearch)
let g:esearch.default_mappings = 0
let g:esearch.win_map = [
            \ [ 'n', '<cr>', ':call b:esearch.open("NewTabdrop")<cr>'],
            \ [ 'n', 't',  ':call b:esearch.open("NETRTabdrop")<cr>'],
            \ [ 'n', 'pp', ':call b:esearch.split_preview_open() | wincmd W<cr>'],
            \ [ 'n', 'q',  ':tabclose<cr>'],
            \]
augroup ESEARCH
    autocmd!
    autocmd ColorScheme * highlight! link esearchMatch Cursor
augroup END
"}}}

Plug 'kkoomen/vim-doge'
Plug 'will133/vim-dirdiff'
Plug 'jalvesaq/vimcmdline' "{{{
let g:cmdline_map_start          = '<LocalLeader>s'
let g:cmdline_map_send           = 'E'
let g:cmdline_map_send_and_stay  = '<LocalLeader>E'
let cmdline_app = {}
let cmdline_app['matlab'] = 'matlab -nojvm -nodisplay -nosplash'
let cmdline_app['python'] = 'ipython'
let cmdline_app['sh'] = 'zsh'
let cmdline_app['zsh'] = 'zsh'
let g:cmdline_vsplit = 1      " Split the window vertically
"}}}

Plug 'wellle/context.vim', {'on_cmd': 'ContextPeek'} "{{{
let g:context_enabled=0
nnoremap <m-i> :ContextPeek<cr>
"}}}
Plug 'embear/vim-localvimrc' "{{{
let g:localvimrc_ask = 0
"}}}
Plug 'rbtnn/vim-vimscript_lasterror', {'on_cmd': 'VimscriptLastError'}
Plug 'mipmip/vim-scimark' "{{{
"}}}
Plug 'andymass/vim-matchup'
Plug 'AndrewRadev/linediff.vim'
Plug 'zhimsel/vim-stay' " vim-stay {{{
set viewoptions=cursor,folds,slash,unix
"}}}

Plug 'git@github.com:ipod825/vim-netranger' "{{{
let g:NETRRifleFile = $HOME."/dotfiles/config/nvim/settings/rifle.conf"
let g:NETRIgnore = ['__pycache__', '*.pyc', '*.o', 'egg-info', 'tags']
let g:NETRColors = {'dir': 39, 'footer': 35, 'exe': 35}
let g:NETRGuiColors = {'dir': '#00afff', 'footer': '#00af5f', 'exe': '#00af5f'}
let g:NETRDefaultMapSkip = ["<cr>"]
let g:NETRRifleDisplayError = v:false
function! DuplicateNode()
    let path = netranger#api#cur_node_path()
    let dir = fnamemodify(path, ':p:h').'/'
    let newname = 'DUP'.fnamemodify(path, ':p:t')
    call netranger#api#cp(path, dir.newname)
endfunction
function! NETRBookMark()
    BookmarkAdd netranger
endfunction

function! NETRBookMarkGo()
    BookmarkGo netranger
endfunction

function! NETRInit()
    call netranger#api#mapvimfn('yp', "DuplicateNode")
    call netranger#api#mapvimfn('m', "NETRBookMark")
    call netranger#api#mapvimfn("\'", "NETRBookMarkGo")
endfunction

let g:NETRCustomNopreview={->winnr()==2 && winnr('$')==2}

autocmd! USER NETRInit call NETRInit()
"}}}

call plug#end()

silent doautocmd USER PLUG_END
