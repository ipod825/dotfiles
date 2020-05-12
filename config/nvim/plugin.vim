" Download vim-plug
let vim_plug_file=expand(g:vim_dir . 'autoload/plug.vim')
if !filereadable(vim_plug_file)
    echo "Installing vim-plug.."
    echo ""
    execute 'silent !mkdir -p ' . g:vim_dir . 'autoload'
    call system('curl -fLo '.g:vim_dir.'autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
endif

augroup POST_PLUG_END
    " This augroup enables us to call functions defined in a plugin before
    " plug#end() call.
    autocmd!
augroup END

call plug#begin(g:vim_dir . 'bundle')
Plug 'junegunn/vim-plug'
Plug 'rakr/vim-one'
Plug 'vim-scripts/gtags.vim'

Plug 'tpope/vim-commentary'
" {{{
nmap <c-_> gcc
vmap <c-_> gc
" }}}
Plug 'luochen1990/rainbow'
" rainbow {{{
let g:rainbow_active = 1
let g:rainbow_conf = {'ctermfgs': ['1', '2', '3', '6']}
" }}}

Plug 'itchyny/lightline.vim'
" lightline {{{
let g:lightline = {
    \ 'colorscheme': 'wombat' ,
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ], ['tagbar'] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileencoding', 'filetype' ] ]
    \  },
    \ 'component': {
    \         'tagbar': ' %{tagbar#currenttag("%s", "", "f")}',
    \ },
    \ }
" }}}
Plug 'majutsushi/tagbar'
" tagbar {{{
cnoreabbrev BB TagbarOpenAutoClose
" }}}

Plug 'vimwiki/vimwiki'
let g:vimwiki_folding='list'
function! VimwikiLinkHandler(link)
try
  execute 'silent !qday '.a:link
  return 1
catch
  echo "This can happen for a variety of reasons ..."
endtry
return 0
endfunction
function! SetupVimWiki()
    vmap <buffer> <m-cr> <Plug>VimwikiNormalizeLinkVisualCR
    vmap <buffer> <m-d> <Plug>VimwikiFollowLink
    vmap <buffer> <m-s> <Plug>VimwikiGoBackLink
endfunction
augroup VIMWIKI
    autocmd!
    autocmd Filetype vimwiki command! -buffer BrowseCurrent
            \ if filewritable(expand('%')) | silent noautocmd w | endif
            \ <bar>
            \ execute 'silent !'.$BROWSER.' '.vimwiki#html#Wiki2HTML(
            \         expand(vimwiki#vars#get_wikilocal('path_html')),
            \         expand('%'))
    autocmd Filetype vimwiki call <sid>SetupVimWiki()
augroup END

Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
" vim-mark {{{
let g:mw_no_mappings = 1
let g:mwDefaultHighlightingPalette = 'maximum'
nnoremap <silent> 8 :let @/=""<cr>:call feedkeys("\<Plug>MarkSet")<cr>
nmap * :let @/=""<cr>:silent MarkClear<cr>:call feedkeys("\<Plug>MarkSet")<cr>
vnoremap <silent> 8 :<c-u>let @/=""<cr>:<C-u>if ! mark#DoMark(v:count, mark#GetVisualSelectionAsLiteralPattern())[0]<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
vnoremap <silent> * :<c-u>let @/=""<cr>:silent MarkClear<cr>:<C-u>if ! mark#DoMark(v:count, mark#GetVisualSelectionAsLiteralPattern())[0]<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
nnoremap <silent><leader>/ :let @/=""<cr>:silent MarkClear<cr>
nmap n <Plug>MarkSearchCurrentNext
nmap N <Plug>MarkSearchCurrentPrev

function! s:MarkSearchResult()
    let search_pat = getreg('/')
    if empty(search_pat)
        return
    endif

    let ind = index(mark#ToList(), search_pat)
    if ind == -1
        call mark#DoMarkAndSetCurrent(v:count, ingo#regexp#magic#Normalize(search_pat))
    endif
    let s:last_search=search_pat
    let @/=""
endfunction

function! s:SelectAllMark()

    call feedkeys("\<Plug>(VM-Start-Regex-Search)".join(mark#ToList(),"\\|")."\<cr>")
    call feedkeys("\<Plug>(VM-Select-All)")
endfunction

nmap <leader>r :call <sid>SelectAllMark()<cr>

augroup VIM-MARK
    autocmd!
    autocmd VimEnter * let @/=""
    autocmd CursorMoved * silent call s:MarkSearchResult()
augroup END
" }}}

Plug 'fatih/vim-go', {'for': 'go'}

Plug 'jiangmiao/auto-pairs'
" auto-pairs {{{
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
" }}}

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-surround'

Plug 'mg979/vim-visual-multi'
" vim-visual-multi {{{
let g:VM_default_mappings = 0
let g:VM_reselect_first = 1
let g:VM_notify_previously_selected = 1
let g:VM_theme = 'iceblue'
let g:VM_maps = {}
let g:VM_maps["Switch Mode"] = 'v'
let g:VM_maps['Find Word'] = '<C-n>'
let g:VM_maps['Skip Region'] = '<C-x>'
let g:VM_maps['Remove Region'] = '<C-p>'
let g:VM_maps['Select All'] = '<leader>a'
let g:VM_maps['Goto Prev'] = '<c-k>'
let g:VM_maps['Goto Next'] = '<c-j>'
let g:VM_maps["Undo"] = 'u'
let g:VM_maps["Redo"] = '<c-r>'
let g:VM_maps["Numbers"] = '<leader>n'


let g:VM_maps["Visual Add"] = '<C-n>'
let g:VM_maps["Visual Find"] = '<C-n>'
let g:VM_maps["Visual Regex"] = '<leader>/'
let g:VM_maps["Visual Cursors"] = '<C-c>'
let g:VM_maps["Visual All"] = '<leader>a'
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
endfun
function! VM_Exit()
    augroup VIM-MARK
        autocmd!
        autocmd CursorMoved * silent call s:MarkSearchResult()
    augroup END
endfunction

Plug 'Shougo/neco-vim'
if exists('*nvim_open_win')
Plug 'ncm2/float-preview.nvim'
endif

Plug 't9md/vim-textmanip'
" {{{
xmap <c-m-k> <Plug>(textmanip-move-up)
xmap <c-m-h> <Plug>(textmanip-move-left)
xmap <c-m-l> <Plug>(textmanip-move-right)
xmap <c-m-j> <Plug>(textmanip-move-down)
" }}}

Plug 'git@github.com:ipod825/julia-unicode.vim', {'for': 'julia'}
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } " align code - helpful for latex table
" vim-easy-align {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}


Plug 'w0rp/ale'
" ale (only used as formatter) {{{
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_lint_on_save = 0
let g:ale_lint_on_text_changed = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_enabled = 0
let g:ale_virtualtext_cursor=1
let g:ale_completion_enabled=0
let g:ale_fix_on_save = 0
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'python': ['yapf', 'isort'],
            \'cpp': ['clang-format']
            \}
" }}}

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh;'}
" LanguageClient-neovim {{{
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
nnoremap <c-]> <nop>
nnoremap <c-t> <nop>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<cr>

" }}}

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif
" deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 0
if !exists('g:deoplete#omni_patterns')
    let g:deoplete#omni_patterns = {}
endif
" }}}

Plug 'lervag/vimtex', {'for': 'tex'}
" vimtex {{{
let g:tex_flavor = 'latex'
let g:vimtex_fold_enabled = 1
let g:polyglot_disabled = ['latex']
let g:vimtex_log_ignore=['25']
let g:vimtex_view_general_viewer = 'zathura'
augroup POST_PLUG_END
if &rtp =~ 'deoplete.nvim'
    call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})
    augroup VIMTEX
        autocmd!
        autocmd Filetype tex call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
    augroup END
endif

let g:tex_conceal="abdgm"
highlight Conceal term=bold cterm=bold ctermbg=236
highlight Conceal cterm=bold ctermfg=255 ctermbg=233
highlight Conceal term=bold cterm=bold ctermbg=red
highlight Conceal cterm=bold ctermfg=255 ctermbg=red
" }}}

Plug 'airblade/vim-rooter' " FindRootDirectory() is used for fzf
" vim-rooter
let g:rooter_manual_only = 1
"}}}

Plug 'sheerun/vim-polyglot'
Plug 'mboughaba/i3config.vim', {'for': 'i3'}
Plug 'SirVer/ultisnips'
" ultisnips {{{
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetsDir=g:vim_dir . 'snippets'
" }}}

Plug 'honza/vim-snippets'

packadd termdebug
" Termdebug {{{
command! Debug execute 'call <sid>Debug()'
command!  -nargs=* DebugGo call <sid>DebugGo(<f-args>)
command!  -nargs=* DebugGoStop call <sid>DebugGoStop()
command!  -nargs=* Test echo <q-args>

function! s:Save_mappings(keys, mode) abort
  let mappings = {}
  for l:key in a:keys
    let mappings[l:key] = maparg(l:key, a:mode)
  endfor
  return mappings
endfu

function! s:Restore_mappings(mappings, mode) abort
  for kv in items(a:mappings)
    if (kv[1]!="")
      execute a:mode.'map '.kv[0]." ".kv[1]
    else
      execute a:mode.'unmap '.kv[0]
      execute a:mode.'unmap '.kv[0]
    endif
  endfor
endfu

function! s:MapDebug()
  let g:saved_normal_mappings = <sid>Save_mappings(['n','s','c','B','C','e','f','U','D','t'], 'n')
  let g:saved_visual_mappings = <sid>Save_mappings(['e'], 'x')
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
  call <sid>Restore_mappings(g:saved_normal_mappings, 'n')
  let g:saved_normal_mappings = {}
  call <sid>Restore_mappings(g:saved_visual_mappings, 'x')
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
  let g:saved_normal_mappings = <sid>Save_mappings(['n','s','c','B','C','e','f','U','D','t'], 'n')
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
  call <sid>Restore_mappings(g:saved_normal_mappings, 'n')
  let g:saved_normal_mappings = {}
  " call <sid>Restore_mappings(g:saved_visual_mappings, 'x')
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

" }}}

Plug 'tpope/vim-fugitive', {'on_cmd': ['Gstatus', 'Gdiff'], 'augroup': 'fugitive'}
" vim-fugitive {{{
cnoreabbrev g tab Git
" }}}

Plug 'camspiers/animate.vim'
let g:animate#duration = 100.0
" Plug 'camspiers/lens.vim'
Plug 'git@github.com:ipod825/lens.vim', {'branch': 'disableoption'}
" lens.vim {{{
function! s:LensDisable()
    if &diff
        return v:true
    endif
    return v:false
endfunction
let g:Lens_custom_disable_check = function('s:LensDisable')
let g:lens#disabled_filetypes = ['netranger', 'gitv', 'esearch']
let g:lens#disabled_buftypes = ['terminal']
let g:lens#specify_dim_by_ratio = v:true
let g:lens#width_resize_min=0.7
let g:lens#width_resize_max=0.7
" }}}

Plug 'tpope/vim-dispatch'

Plug 'git@github.com:ipod825/gitv'
" gitv {{{
cnoreabbrev gv Gitv --all
cnoreabbrev gvb Gitv! --all
let g:Gitv_WipeAllOnClose = 1
let g:Gitv_DoNotMapCtrlKey = 1
let g:Gitv_OpenPreviewOnLaunch = 0
" }}}
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'terryma/vim-expand-region'
Plug 'whatyouhide/vim-textobj-xmlattr', { 'for': ['html', 'xml'] }
" {{{ vim-expand-region
vmap <m-k> <Plug>(expand_region_expand)
vmap <m-j> <Plug>(expand_region_shrink)
nmap <m-k> <Plug>(expand_region_expand)
nmap <m-j> <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iv'  :0,
      \ 'av'  :0,
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'a"'  :0,
      \ 'i''' :0,
      \ 'a''' :0,
      \ 'i]'  :1,
      \ 'ib'  :1,
      \ 'ab'  :1,
      \ 'iB'  :1,
      \ 'aB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ 'ix'  :0,
      \ 'ax'  :0,
      \ }
" }}}


Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-abolish'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" fzf.vim {{{
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.95 } }
let $FZF_DEFAULT_COMMAND = 'find .'
let g:fzf_action = { 'ctrl-e': 'edit', 'Enter': 'Tabdrop', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

nnoremap <silent> / :call SearchWord()<cr>
nnoremap ? /
nnoremap <c-o> :exec "Files " . FindRootDirectory()<cr>
tnoremap <c-o> <c-\><c-n>:exec "Files " . FindRootDirectory()<cr>
nnoremap <silent><leader>e :call fzf#run(fzf#wrap({
      \   'source':  systemlist('$HOME/dotfiles/misc/watchfiles.sh nvim'),
        \}))<cr>

if !exists("g:utility_commands_loaded")
  let g:utility_commands = ['Buffers','YankAbsPath', 'YankBaseName', 'OpenRelatedFile', 'ClearSign', 'SaveWithoutFix', 'RemoveRedundantWhiteSpace']
let g:utility_commands_loaded = 1
endif
nnoremap <silent><leader><Enter> :call fzf#run(fzf#wrap({
        \   'source':  sort(g:utility_commands),
        \   'sink': function('FZFExecFnOrCmd'),
        \}))<cr>

command! OpenRecnetFile call fzf#run({
\ 'source':  filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|N:\\|term\\|^/tmp/\\|.git/'"),
\ 'sink':    'Tabdrop',
\})
cnoreabbrev f OpenRecnetFile

command! OpenRecentDirectory call fzf#run({
\ 'source':  map(filter(copy(v:oldfiles), "v:val =~ 'N:'"), 'v:val[2:]'),
\ 'sink':    'Tabdrop',
\})
cnoreabbrev d OpenRecentDirectory


function! FZFExecFnOrCmd(name)
  if exists(":".a:name)
    execute a:name
  else
    execute 'call '.a:name.'()'
  endif
endfunction

function! SaveWithoutFix()
    let g:ale_fix_on_save = 0
    write
    let g:ale_fix_on_save = 1
endfunction

function! ClearSign()
    exe 'sign unplace * buffer='.bufnr()
endfunction

function! OpenRelatedFile()
    let name=expand('%:t:r')
  exec "Files " . FindRootDirectory()
  call feedkeys("i")
  call feedkeys(name)
endfunction

function! YankAbsPath()
  let @+=expand('%:p')
  let @"=expand('%:p')
endfunction

function! YankBaseName()
  let @+=expand('%:p:t')
  let @"=expand('%:p:t')
endfunction

function! RemoveRedundantWhiteSpace()
    let l:save = winsaveview()

    if mode()=='v'
        '<,'>s/\(\S\)\s\+\(\S\)/\1 \2/g
    else
        %s/\(\S\)\s\+\(\S\)/\1 \2/g
    endif

    call winrestview(l:save)
endfunction

function! s:Line_handler(l)
    let keys = split(a:l, ':')
    exec keys[0]
    call feedkeys('zz')
endfunction

function! SearchWord()
    let s:fzf_ft=&ft
    augroup FzfSearchWord
        autocmd!
        " autocmd FileType fzf if strlen(s:fzf_ft) && s:fzf_ft!= "man" | silent! let &ft=s:fzf_ft | endif
    augroup END
        silent call fzf#run(fzf#wrap({
                    \   'source':  map(getline(1, '$'), '(v:key + 1) . ": " . v:val '),
                    \   'sink':    function('s:Line_handler'),
                    \   'options': '+s -e --ansi',
                    \}))
    let s:fzf_ft=''
endfunction
"}}}

Plug 'MattesGroeger/vim-bookmarks'

Plug 'gcmt/taboo.vim'
" taboo{{{
let g:taboo_tab_format='%I%m%f '
let g:taboo_renamed_tab_format='%I%m%l '
fu! TabooCustomExpand(name)
    let out = a:name
    let i = 20
    if len(out)>i
        let out = a:name[:i-2].".."
    endif
    return out
endfu
" }}}
Plug 'justinmk/vim-sneak'
" sneak {{{
" let g:sneak#label = 1
nmap <nop> <Plug>Sneak_s
nmap <nop> <Plug>Sneak_S
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap H <Plug>Sneak_,
nmap L <Plug>Sneak_;
vmap H <Plug>Sneak_,
vmap L <Plug>Sneak_;
let g:sneak#absolute_dir=1
" }}}
Plug 'maxbrunsfeld/vim-yankstack' " clipboard stack
" vim-yankstack {{{
let g:yankstack_yank_keys = ['y', 'd', 'x', 'c']
nmap <M-p> <Plug>yankstack_substitute_older_paste
nmap <M-n> <Plug>yankstack_substitute_newer_paste
" }}}
" Plug 'eugen0329/vim-esearch'
Plug 'eugen0329/vim-esearch', {'branch': 'development'}
" vim-esearch {{{
let g:esearch = {
  \ 'adapter':          'ag',
  \ 'bckend':          'nvim',
  \ 'out':              'win',
  \ 'batch_size':       1000,
  \ 'prefill':    ['visual', 'hlsearch', 'cword', 'last'],
  \ 'default_mappings': 1,
  \}
nmap <leader>f <Plug>(esearch)
vmap <leader>f <Plug>(esearch)
let g:esearch.filemanager_integration=v:false
let g:esearch.win_map = [
            \ [ 'n', '<cr>',  ':call b:esearch.open("NewTabdrop")<cr>'],
            \ [ 'n', 't',  ':call b:esearch.open("NETRTabdrop")<cr>'],
            \ [ 'n', 'q',  ':tabclose<cr>'],
            \]
augroup ESEARCH
    autocmd!
    autocmd User esearch_win_config
                \   let b:autopreview = esearch#debounce(b:esearch.split_preview, 100)
                \ | autocmd CursorMoved <buffer> call b:autopreview.apply('vsplit')
augroup END
" }}}

Plug 'kkoomen/vim-doge'
Plug 'will133/vim-dirdiff'
Plug 'machakann/vim-swap'
Plug 'jalvesaq/vimcmdline'
" vimcmdline {{{
let g:cmdline_map_start          = '<LocalLeader>s'
let g:cmdline_map_send           = 'E'
let g:cmdline_map_send_and_stay  = '<LocalLeader>E'
let cmdline_app = {}
let cmdline_app['matlab'] = 'matlab -nojvm -nodisplay -nosplash'
let cmdline_app['python'] = 'ipython'
let cmdline_app['sh'] = 'zsh'
let cmdline_app['zsh'] = 'zsh'
let g:cmdline_vsplit      = 1      " Split the window vertically
" }}}

Plug 'embear/vim-localvimrc'
" vim-localvimrc {{{
let g:localvimrc_ask = 0
" }}}
Plug 'git@github.com:ipod825/vim-tabdrop'
" vim-tabdrop {{{
augroup TABDROP
    autocmd!
    autocmd FileType qf nnoremap <buffer> <cr> :QfTabdrop<cr>
    autocmd FileType qf nnoremap <buffer> q :quit<cr>
augroup END
"}}}

Plug 'mbbill/undotree'                  " unlimited undo
" undotree {{{
if has("persistent_undo")
    execute "set undodir=".g:vim_dir."undo/"
    set undofile
endif
" }}}

Plug 'AndrewRadev/linediff.vim'
Plug 'vim-scripts/gtags.vim'
Plug 'zhimsel/vim-stay'
" {{{ vim-stay
set viewoptions=cursor,folds,slash,unix
" }}}
Plug 'voldikss/vim-floaterm'
" {{{ vim-floaterm
nnoremap <m-f> :FloatermToggle<cr>
tnoremap <m-f> <c-\><c-n>:FloatermToggle<cr>
let g:floaterm_width=0.95
let g:floaterm_height=0.8
" }}}

Plug 'git@github.com:ipod825/vim-netranger'
" vim-netranger {{{
let g:NETRRifleFile = $HOME."/dotfiles/config/nvim/settings/rifle.conf"
let g:NETRIgnore = ['__pycache__', '*.pyc', '*.o', 'egg-info']
let g:NETRColors = {'dir': 39, 'footer': 35, 'exe': 35}
let g:NETRGuiColors = {'dir': '#00afff', 'footer': '#00af5f', 'exe': '#00af5f'}
function! DuplicateNode()
    call netranger#cp(netranger#cur_node_path(), netranger#cur_node_path().'DUP')
endfunction

function! NETRCloseTab()
    if tabpagenr()>1
        tabclose
    else
        qall
    endif
endfunction

function! NETRInit()
    call netranger#mapvimfn('yp', "DuplicateNode")
    call netranger#mapvimfn('q', "NETRCloseTab")
endfunction

autocmd! USER NETRInit call NETRInit()
" }}}

call plug#end()

silent doautocmd USER PLUG_END
