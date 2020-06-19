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

Plug 'rakr/vim-one'
augrou ONE
    autocmd!
    autocmd USER PLUG_END colorscheme one
    autocmd USER PLUG_END call one#highlight("CursorLine", '', '213b40', 'bold')
    autocmd USER PLUG_END call one#highlight("Visual", '', '213b40', '')
augrou END

Plug 'tpope/vim-scriptease'
Plug 'vim-scripts/gtags.vim'
Plug 'wsdjeg/vim-fetch'

Plug 'tpope/vim-commentary' "{{{
nmap <c-_> gcc
vmap <c-_> gc
augroup COMMENTARY
    autocmd Filetype c,cpp setlocal commentstring=//\ %s
augroup END
"}}}

"Plug 'tpope/vim-fugitive', {'on_cmd': ['Gstatus', 'Gdiff'], 'augroup': 'fugitive'} "{{{
"let g:fugitive_auto_close = get(g:, 'fugitive_auto_close', v:false)
"augroup FUGITIVE
"    autocmd!
"    autocmd Filetype fugitive nmap <buffer> <leader><space> =
"    autocmd Filetype fugitive autocmd BufEnter <buffer> if g:fugitive_auto_close | let g:fugitive_auto_close=v:false | quit | endif
"    autocmd Filetype gitcommit autocmd BufWinLeave <buffer> ++once let g:fugitive_auto_close=v:true
"augroup END
"function! s:Glog()
"    return "sp | wincmd T | Gclog"
"endfunction
"cnoreabbrev <expr> glog <sid>Glog()
"cnoreabbrev gg tab Git
""}}}

Plug 'lambdalisue/gina.vim' "{{{
cnoreabbrev G Gina status -s --opener=split
augroup GINA
    autocmd!
    autocmd USER PLUG_END call s:SetupGina()
augroup END
function! s:SetupGina()
	call gina#custom#mapping#nmap('/.*', '<cr>','<Plug>(gina-edit-tab)')
	call gina#custom#mapping#nmap('status', '-','<Plug>(gina-index-toggle)', {'nowait': v:true})
	call gina#custom#mapping#nmap('status', 'dd','<Plug>(gina-diff-vsplit)')
	call gina#custom#mapping#nmap('status', 'cc',':quit<cr>:Gina commit --opener=split<CR>')
endfunction
"}}}


Plug 'itchyny/lightline.vim' "{{{
let g:asyncrun_status=get(g:,'asyncrun_status',"success")
" let g:lightline = {
"             \ 'colorscheme': 'wombat' ,
"             \ 'active': {
"             \   'left': [['mode', 'paste'],
"             \            ['readonly', 'filename'],
"             \            ['fugitiveobj']],
"             \   'right': [['lineinfo'],
"             \              ['percent'],
"             \              ['gitbranch'], ['asyncrun']]
"             \  },
"             \ 'inactive': {
"             \   'left': [['filename'],
"             \            ['fugitiveobj']],
"             \   'right': [['lineinfo'],
"             \              ['percent'],
"             \               ['gitbranch']]},
"             \ 'component': {
"             \         'tagbar': '⚓'.'%{tagbar#currenttag("%s", "", "f")}',
"             \         'gitbranch': '%{GitBranch()}',
"             \         'asyncrun': '%{g:asyncrun_status=="running"?g:asyncrun_status:""}',
"             \         'fugitiveobj': '%{FugitiveObj()}'
"             \ },
"             \ }
let g:lightline = {
            \ 'colorscheme': 'wombat' ,
            \ 'active': {
            \   'left': [['mode', 'paste'],
            \            ['readonly', 'filename'],
            \            ],
            \   'right': [['lineinfo'],
            \              ['percent'],
            \              ['gitst'],['asyncrun']]
            \  },
            \ 'inactive': {
            \   'left': [['filename'],
            \            ],
            \   'right': [['lineinfo'],
            \              ['percent'],
            \               ]},
            \ 'component': {
            \         'tagbar': '⚓'.'%{tagbar#currenttag("%s", "", "f")}',
            \         'gitst': '%{gina#component#repo#preset("fancy")}',
            \         'gitbranch': '%{GitBranch()}',
            \         'asyncrun': '%{g:asyncrun_status=="running"?g:asyncrun_status:""}',
            \         'fugitiveobj': '%{FugitiveObj()}'
            \ },
            \ }
function! GitBranch()
    let res = fugitive#head()
    if empty(res)
        let res = system('git rev-parse HEAD')[:5]
    endif
    return "⎇ ".res
endfunction
function! FugitiveObj()
    let res = expand('%:p')
    let ind = match(res, '.git//')
    if ind<0
        return ''
    endif
    let res = res[ind+6:]
    let ind = match(res, '/')
    return "⎇ ".res[:min([5, ind-1])]
endfunction

function MyGitStatus() abort
  let staged = gina#component#status#staged()
  let unstaged = gina#component#status#unstaged()
  let conflicted = gina#component#status#conflicted()
  return printf(
        \ 's: %s, u: %s, c: %s',
        \ staged,
        \ unstaged,
        \ conflicted,
        \)
endfunction
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

Plug 'majutsushi/tagbar' "{{{
cnoreabbrev BB TagbarOpenAutoClose
"}}}

Plug 'skywind3000/asyncrun.vim' "{{{
augroup ASYNCRUN
    autocmd!
    autocmd User AsyncRunStop if g:asyncrun_code!=0 | copen | wincmd T | endif
augroup END
cnoreabbrev gps AsyncRun git push
cnoreabbrev gpl AsyncRun git pull
"}}}
Plug 'tpope/vim-endwise'

Plug 'tpope/vim-surround'

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


Plug 'w0rp/ale' " (only used as formatter) {{{
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

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh;'} "{{{
let g:LanguageClient_diagnosticsList = "Disabled"
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
    catch /E433:/
        call LanguageClient_textDocument_definition({'gotoCmd': 'Tabdrop'})
    endtry
endfunction
nnoremap <m-d> :call <sid>Gotodef()<cr>
nmap <m-s> :TabdropPopTag<cr><esc>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<cr>
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
        call deoplete#custom#var('omni', 'input_patterns', {
                    \ 'tex': g:vimtex#re#deoplete
                    \})
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

Plug 'sheerun/vim-polyglot'
Plug 'mboughaba/i3config.vim', {'for': 'i3'}
Plug 'SirVer/ultisnips' "{{{
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetDirectories=[g:vim_dir.'UltiSnips']
"}}}

Plug 'honza/vim-snippets'
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



Plug 'git@github.com:ipod825/war.vim' "{{{
 augroup WAR
     autocmd!
     autocmd Filetype qf :call war#fire(-1, 0.8, -1, 0.2)
     autocmd Filetype fugitive :call war#fire(-1, 1, -1, 0)
     autocmd Filetype gina-status :call war#fire(-1, 1, -1, 0)
     autocmd Filetype gina-commit :call war#fire(-1, 1, -1, 0)
     autocmd Filetype diff :call war#fire(-1, 1, -1, 0)
     autocmd Filetype git :call war#fire(-1, 0.8, -1, 0.1)
     autocmd Filetype esearch :call war#fire(0.8, -1, 0.2, -1)
     autocmd Filetype bookmark :call war#fire(-1, 1, -1, -1)
 augroup END
" }}}
Plug 'AndrewRadev/linediff.vim'

Plug 'junegunn/gv.vim', {'on_cmd': 'GV'} "{{{
cnoreabbrev gv GV --branches
augroup GVmapping
    autocmd FileType GV nmap <buffer> r :quit<cr>:gv<cr>
    autocmd FileType GV call s:CustomizeGV()
augroup END

function! s:CustomizeGV()
    nnoremap <buffer> cc :call <sid>GVCheckout()<cr>
    nnoremap <buffer> dd :call <sid>GVDiff()<cr>
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

function! s:GVCheckout()
    let l:cand = [gv#sha()]
    let l:branches = matchstr(getline('.'), '([^)]*) ')
    if !empty(l:branches)
        let l:branches = l:branches[1:len(l:branches)-3]
        call extend(l:cand, split(l:branches, ','))
        let l:cand = map(l:cand, function('<sid>BranchFilter'))
    endif
    if len(l:cand)>1
        call fzf#run(fzf#wrap({
                \ 'source': sort(l:cand),
                \ 'sink': 'AsyncRun git checkout',
            \}))
    else
        exec 'AsyncRun git checkout '.l:cand[0]
    endif
endfunction

function! s:GVDiff()
    " exec 'Git difftool -y '.gv#sha().' HEAD'
    let l:sha = gv#sha()
    vnew
    set filetype=git
    set buftype=nowrite
    exec 'Gread! diff '.l:sha.' '.system('git rev-parse HEAD')
    setlocal nomodifiable
    call fugitive#MapCfile()
    call fugitive#MapJumps()
endfunction
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


Plug 'tpope/vim-abolish'
Plug 'mh21/errormarker.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' "{{{
autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.95 } }
let $FZF_DEFAULT_COMMAND = 'find .'
let g:fzf_action = { 'ctrl-e': 'edit', 'Enter': 'Tabdrop', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }
"}}}

Plug 'git@github.com:ipod825/vim-bookmark' "{{{
nnoremap m :BookmarkAddPos<cr>
nnoremap <a-m> :BookmarkDelPos<cr>
cnoreabbrev bma BookmarkAdd
cnoreabbrev bmd BookmarkDel
nnoremap ' :BookmarkGo<cr>
let g:bookmark_opencmd='Tabdrop'
function! s:Bookmark_pos_context_fn()
    return [tagbar#currenttag("%s", "", "f"), getline('.')]
endfunction
let g:Bookmark_pos_context_fn = function('s:Bookmark_pos_context_fn')
" }}}

Plug 'git@github.com:ipod825/taboo.vim' "{{{
let g:taboo_tab_format='%I%m%f❚'
let g:taboo_renamed_tab_format='%I%m%l❚'
fu! TabooCustomExpand(name)
    let out = a:name
    let i = 20
    if len(out)>i
        let out = a:name[:i-2].".."
    endif
    return out
endfu
"}}}

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
Plug 'maxbrunsfeld/vim-yankstack' " clipboard stack  {{{
let g:yankstack_yank_keys = ['y', 'd', 'x', 'c']
nmap <M-p> <Plug>yankstack_substitute_older_paste
nmap <M-n> <Plug>yankstack_substitute_newer_paste
"}}}

Plug 'eugen0329/vim-esearch', {'branch': 'development'} "{{{
let g:esearch = {
            \ 'adapter':          'ag',
            \ 'bckend':          'nvim',
            \ 'out':              'win',
            \ 'batch_size':       1000,
            \ 'default_mappings': 1,
            \}
nmap <leader>f <Plug>(operator-esearch-prefill)iw
vmap <leader>f <Plug>(esearch)
let g:esearch.filemanager_integration=v:false
let g:esearch.default_mappings = 0
let g:esearch.win_map = [
            \ [ 'n', '<cr>', ':call b:esearch.open("NewTabdrop")<cr>'],
            \ [ 'n', 't',  ':call b:esearch.open("NETRTabdrop")<cr>'],
            \ [ 'n', 'pp', ':call b:esearch.split_preview_open() | wincmd W<cr>'],
            \ [ 'n', 'q',  ':tabclose<cr>'],
            \]
augroup ESEARCH
    autocmd!
    autocmd USER PLUG_END hi esearchMatch cterm=bold ctermfg=145 ctermbg=16 gui=bold guifg=#000000 guibg=#5a93f2
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
let g:cmdline_vsplit      = 1      " Split the window vertically
"}}}

Plug 'wellle/context.vim', {'on_cmd': ['ContextPeek']} "{{{
let g:context_enabled=0
nnoremap <m-i> :ContextPeek<cr>
"}}}
Plug 'embear/vim-localvimrc' "{{{
let g:localvimrc_ask = 0
Plug 'git@github.com:ipod825/vim-tabdrop' "{{{
"}}}

Plug 'rbtnn/vim-vimscript_lasterror'
Plug 'Yggdroot/indentLine'
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
    let path = netranger#cur_node_path()
    let dir = fnamemodify(path, ':p:h').'/'
    let newname = 'DUP'.fnamemodify(path, ':p:t')
    call netranger#cp(path, dir.newname)
endfunction
function! NETRBookMark()
    BookmarkAdd netranger
endfunction

function! NETRBookMarkGo()
    BookmarkGo netranger
endfunction

function! NETRInit()
    call netranger#mapvimfn('yp', "DuplicateNode")
    call netranger#mapvimfn('m', "NETRBookMark")
    call netranger#mapvimfn("\'", "NETRBookMarkGo")
endfunction

let g:NETRCustomNopreview={->winnr()==2 && winnr('$')==2}

autocmd! USER NETRInit call NETRInit()
"}}}

call plug#end()

silent doautocmd USER PLUG_END
