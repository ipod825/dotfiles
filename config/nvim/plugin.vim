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
Plug 'rbtnn/vim-vimscript_lasterror', {'on_cmd': 'VimscriptLastError'}
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

Plug 'tpope/vim-commentary' "{{{
nmap <c-_> gcc
vmap <c-_> gc
augroup COMMENTARY
    autocmd Filetype c,cpp setlocal commentstring=//\ %s
augroup END
"}}}

Plug 'rakr/vim-one' "{{{
augrou ONE
    autocmd!
    autocmd ColorScheme * call one#highlight("CursorLine", '', '2e5057', 'bold')
    autocmd ColorScheme * call one#highlight("Visual", '', '2e5057', '')
    autocmd ColorScheme * call one#highlight("Comment", '7c7d7d', '', '')
augrou END
"}}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' "{{{
autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
autocmd VimEnter * command! -bang -nargs=? Buffers call fzf#vim#buffers(<q-args>, {'options': '--no-preview'}, <bang>0)
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.95 } }
let g:fzf_action = { 'ctrl-e': 'edit', 'Enter': 'Tabdrop', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_ft=''
augroup FZF
    autocmd!
    autocmd! FileType fzf if strlen(g:fzf_ft) | silent! let &ft=g:fzf_ft | endif
augroup END
"}}}

Plug 'wsdjeg/vim-fetch'
Plug 'git@github.com:ipod825/vim-tabdrop'
Plug 'Yggdroot/indentLine' "{{{
let g:indentLine_concealcursor='nvc'
"}}}

Plug 'jreybert/vimagit', {'on_cmd': 'Magit'} "{{{
augroup MAGIT
    autocmd!
    autocmd Filetype magit wincmd T
augrou END
"}}}

Plug 'lambdalisue/gina.vim' "{{{
let g:gina#action#index#discard_directories=1
cnoreabbrev G Gina status -s
cnoreabbrev gbr Gina branch +tabmove\ -1
cnoreabbrev glg Gina log --branches --graph
cnoreabbrev glc exec "Gina log --branches --graph -- ".expand("%:p")
cnoreabbrev gps Gina push
cnoreabbrev gpl Gina pull
cnoreabbrev grc Gina!! rebase --continue
augroup GINA
    autocmd!
    autocmd USER PLUGEND call s:SetupGina()
    autocmd Filetype gina-log call matchadd('ErrorMsg', '.*HEAD.*')
augroup END

augroup GIT
    autocmd!
    autocmd Filetype git nnoremap <buffer> cc :call <sid>GitCheckOutFile()<cr><cr>
    autocmd Filetype git nnoremap <buffer> <cr> <c-w>v:call gina#core#diffjump#jump()<cr>
    autocmd Filetype git exec 'lcd '.system('git rev-parse --show-toplevel')
    autocmd Filetype git setlocal foldmethod=syntax
augroup END

function! s:GitCheckOutFile()
    let l:file_name_line = search('^diff', 'bnc')
    if l:file_name_line ==0
        echoerr "No file found!"
        return
    endif
    let l:hash = expand('%:t')
    let l:fname = split(getline(l:file_name_line)[13:])[0]
    let l:basename = fnamemodify(l:fname, ':p:t')
    exec '!git show '.l:hash.':'.l:fname.' > ~/'.l:basename.'-'.l:hash
endfunction

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
	call gina#custom#mapping#nmap('status', 'ca',':quit<cr>:Gina commit --amend --allow-empty<cr>')
    call gina#custom#mapping#nmap('log', '<cr>','<Plug>(gina-show-vsplit)')
    call gina#custom#mapping#nmap('log', 'dd','<Plug>(gina-show-vsplit)')
    call gina#custom#mapping#nmap('log', 'DD','<Plug>(gina-changes-between)')
    call gina#custom#mapping#nmap('log', '<m-w>',':set wrap!<cr>')
    call gina#custom#mapping#nmap('log', 'cc',':call GinaLogCheckout()<cr>')
    call gina#custom#mapping#nmap('log', 'cb',':call GinaLogCheckoutNewBranch()<cr>')
    call gina#custom#mapping#nmap('log', 'r',':call GinaLogRebase()<cr>')
    call gina#custom#mapping#vmap('log', 'r',':<c-u>call GinaLogVisualRebase()<cr>')
    call gina#custom#mapping#nmap('log', 'm',':call GinaLogMarkTargetHash()<cr>')
    call gina#custom#mapping#nmap('log', '<m-s-d>',':call GinaLogDeleteBranch()<cr>', {'silent': 1})
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
    call gina#custom#mapping#nmap('branch', 'r','<Plug>(gina-commit-rebase)')
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
    elseif a:v=='grafted'
        return
    elseif a:v=~ 'refs/'
        return
    elseif a:v=~ 'HEAD ->'
        return a:v[8:]
    else
        return a:v
    endif
endfunction

function! s:GinaLogRefreshFzfCmd(cmd)
    return {arg-> execute(a:cmd.' '.arg) || timer_start(150, {_->execute('edit')})}
endfunction

function! s:GinaLogRefresh()
    edit
    call matchadd('RedrawDebugRecompose', w:target_branch)
endfunction

function! s:GinaLogGetBranches(line_nr)
    let l:branch_str = matchstr(getline(line('.')), ';1m ([^)]*)')[4:]
    if !empty(l:branch_str)
        let l:branches = split(l:branch_str[1:len(l:branch_str)-2], ', ')
        return filter(map(l:branches, function('<sid>BranchFilter')), '!empty(v:val)')
    endif
    return []
endfunction

function! s:GinaLogCandidate()
    return s:GinaLogGetBranches(line('.')) + [matchstr(getline('.'), '[0-9a-f]\{6,9\}')]
endfunction

function! GinaLogMarkTargetHash()
    let w:target_branch = s:GinaLogCandidate()[-1]
    if get(w:, 'mark_id', -1) >=0
        call matchdelete(w:mark_id)
    endif
    let w:mark_id = matchadd('RedrawDebugRecompose', w:target_branch)
endfunction


function! GinaLogDeleteBranch()
    call fzf#run(fzf#wrap({
            \ 'source': s:GinaLogGetBranches(line('.')),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina!! branch -D'),
            \ 'options': '+s -1',
        \}))
endfunction

function! GinaLogVisualRebase()
    let l:target_branch = get(w:, 'target_branch', '')
    if empty(l:target_branch)
        echoerr "No target branch!"
        return
    endif

    let [line_start,line_end] = [getpos("'<")[1], getpos("'>")[1]]
    let l:branches = []
    for l:line_nr in range(line_start,line_end)
        let l:brs = s:GinaLogGetBranches(l:line_nr)
        if len(l:brs)==0
            echoerr "No branches on line".l:line_nr
            return
        elseif len(l:brs)!=1
            echoerr "No unique branch on line".l:line_nr
            return
        endif
        call add(l:branches, l:brs[0])
    endfor

    let l:branches = [l:target_branch] + reverse(l:branches)
    let l:ori_branch = system('git branch --show-current')
    for l:i in range(len(l:branches)-1)
        let l:target = l:branches[0]
        let l:source = l:branches[1]
        call remove(l:branches, 0)
        exec 'silent !git checkout '.l:source
        if system('git rebase --onto '.l:target.' HEAD~1') =~ 'CONFLICT'
            echoerr 'Conflict when rebasing '.l:source.' to '.l:target.'. Fix it before continue.'
            call s:GinaLogRefresh()
            return
        endif
    endfor
    exec 'silent !git checkout '.l:ori_branch
    call s:GinaLogRefresh()
endfunction

function! GinaLogCheckout()
    call fzf#run(fzf#wrap({
            \ 'source': s:GinaLogCandidate(),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina checkout'),
            \ 'options': '+s -1',
        \}))
endfunction

function! GinaLogCheckoutNewBranch()
    let l:nb = input('New branch name: ')
    call fzf#run(fzf#wrap({
            \ 'source': s:GinaLogCandidate(),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina checkout -b '.l:nb),
            \ 'options': '+s -1',
        \}))
    call s:GinaLogRefresh()
endfunction

function! GinaLogRebase()
    call fzf#run(fzf#wrap({
            \ 'source': s:GinaLogCandidate(),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina!! rebase -i '),
            \ 'options': '+s -1',
        \}))
endfunction

function! GinaLogReset(opt)
    exec 'Gina reset 'a:opt.' '.s:GinaLogCandidate()[0]
    call s:GinaLogRefresh()
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

Plug 'git@github.com:ipod825/msearch.vim' "{{{
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
"}}}

Plug 'fatih/vim-go', {'for': 'go'}
Plug 'voldikss/vim-translator', {'on': 'TranslateW'} "{{{
"}}}

Plug 'chaoren/vim-wordmotion' "{{{
let g:wordmotion_nomap = 1
nmap w <Plug>WordMotion_w
vmap w <Plug>WordMotion_e
omap w <Plug>WordMotion_e
nmap e <Plug>WordMotion_e
vmap e <Plug>WordMotion_e
nmap b <Plug>WordMotion_b
vmap b <Plug>WordMotion_b
vmap iv <Plug>WordMotion_iw
omap iv <Plug>WordMotion_iw
"}}}

Plug 'cohama/lexima.vim' "{{{
inoremap <m-e> <esc>:call <sid>AutoPairsJump()<cr>
function! s:AutoPairsJump()
    normal! l
    let l:b = getline('.')[col('.')+1]
    normal! dl
    if match(l:b, "[\"' ]")  == -1
        call feedkeys('e')
    endif
    call feedkeys('pi')
endfunction
"}}}

Plug 'skywind3000/asyncrun.vim' "{{{
augroup ASYNCRUN
    autocmd!
    autocmd User AsyncRunStop if g:asyncrun_code!=0 | copen | wincmd T | endif
augroup END
"}}}

Plug 'tpope/vim-endwise'
Plug 'mg979/vim-visual-multi', {'branch': 'test'} "{{{
let g:VM_default_mappings = 0
let g:VM_reselect_first = 1
let g:VM_notify_previously_selected = 1
let g:VM_theme = 'iceblue'
let g:VM_maps = {}
let g:VM_maps["Switch Mode"] = 'v'
let g:VM_maps['Find Word'] = '<c-n>'
let g:VM_maps['Skip Region'] = '<c-x>'
let g:VM_maps['Remove Region'] = '<c-p>'
let g:VM_maps['Goto Prev'] = '<c-k>'
let g:VM_maps['Goto Next'] = '<c-j>'
let g:VM_maps['Undo'] = 'u'
let g:VM_maps['Redo'] = '<c-r>'
let g:VM_maps['Numbers'] = '<leader>n'
let g:VM_maps['Visual Add'] = '<c-n>'
let g:VM_maps['Visual Find'] = '<c-n>'
let g:VM_maps['Visual Regex'] = '<leader>/'
let g:VM_maps['Visual Cursors'] = '<c-c>'
let g:VM_maps["Visual Reduce"] = '<leader>r'
let g:VM_maps["Add Cursor At Pos"] = '<c-c>'
let g:VM_maps['Increase'] = '+'
let g:VM_maps['Decrease'] = '-'

let g:VM_custom_motions  = {'<m-h>': '^', '<m-l>': '$'}
let g:VM_custom_noremaps  = {'])': '])', ']]': ']]', ']}':']}', 'w':'e'}

fun! VM_Start()
    imap <buffer> jk <Esc>
    imap <buffer> <c-h> <left>
    imap <buffer> <c-l> <right>
    imap <buffer> <c-j> <down>
    imap <buffer> <c-k> <up>
    imap <buffer> <m-h> <esc><m-h>i
    imap <buffer> <m-l> <esc><m-l>i
    nmap <buffer> J <down>
    nmap <buffer> K <up>
    nmap <buffer> H <Left>
    nmap <buffer> L <Right>
endfun

function! VM_Exit()
    iunmap <buffer> jk
    iunmap <buffer> <c-h>
    iunmap <buffer> <c-l>
    iunmap <buffer> <c-j>
    iunmap <buffer> <c-k>
    iunmap <buffer> <m-h>
    iunmap <buffer> <m-l>
    nunmap <buffer> J
    nunmap <buffer> K
    nunmap <buffer> H
    nunmap <buffer> L
endfunction

function! s:SelectAllMark()
    exec 'VMSearch '.msearch#joint_pattern()
    call feedkeys("\<Plug>(VM-Select-All)")
    call feedkeys("\<Plug>(VM-Goto-Prev)")
endfunction
function! s:VSelectAllMark()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    exec line_start.','.line_end-1.' VMSearch '.msearch#joint_pattern()
endfunction
function! s:VSelectAllMark()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    exec line_start.','.line_end.' VMSearch '.msearch#joint_pattern()
endfunction

nnoremap <leader>r :call <sid>SelectAllMark()<cr>
vnoremap <leader>r :<c-u>call <sid>VSelectAllMark()<cr>
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

if has('nvim') "{{{
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins' }
endif
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
    if has("*deoplete#custom#var")
        autocmd Filetype tex call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
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

Plug 'puremourning/vimspector' "{{{
"}}}

Plug 'Shougo/echodoc.vim'
" echodoc {{{
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'floating'
" }}}

packadd termdebug "{{{
command! Debug execute 'call <sid>Debug()'
command!  -nargs=* DebugGo call <sid>DebugGo(<f-args>)
command!  -nargs=* DebugGoStop call <sid>DebugGoStop()
command!  -nargs=* Test echo <q-args>

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

if has("nvim") "{{{
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
function! s:setup_treesitter()
" try
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {'bash','cpp','css','go',
                \'html','javascript','lua','markdown',
                \'python','yaml'},
    highlight = {
        enable = true,
        disable = {'txt'}
    },
}
EOF
" catch
" endtry
endfunction

augroup NVIMTREESITTER
    autocmd!
    autocmd USER PLUGEND call <sid>setup_treesitter()
augroup END
else
    set foldmethod=syntax
endif
"}}}

Plug 'vim-test/vim-test' "{{{
function! YankNearestTest()
    let position = {
                \'file': fnamemodify(expand('%:p'), ':.'),
                \'line': line('.'),
                \'col':   col('.')}
    let runner = test#determine_runner(position['file'])

    let @"=test#{runner}#build_position('nearest', position)[0]
endfunction
call AddUtilComand('YankNearestTest')
"}}}
Plug 'kana/vim-textobj-user'
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
    autocmd Filetype bookmark nmap <buffer> <c-t> :call bookmark#goimpl('Tabdrop')<cr>
augroup END
" }}}

Plug 'machakann/vim-sandwich'
Plug 'justinmk/vim-sneak' "{{{
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S
let g:sneak#label = 1
let g:sneak#absolute_dir=1
"}}}

Plug 'machakann/vim-swap' " swap parameters

Plug 'svermeulen/vim-yoink' "{{{
let g:yoinkIncludeDeleteOperations=1
function! SelectYankHandler(text)
    let @"=a:text
    normal! p
endfunction
function! SelectYank()
    let g:fzf_ft = &ft
    silent call fzf#run(fzf#wrap({
                \ 'source': filter(map(yoink#getYankHistory(),"v:val.text"), "len(v:val)>1"),
                \ 'sink': function('SelectYankHandler'),
                \}))
    let g:fzf_ft=''
endfunction
call AddUtilComand('SelectYank')
"}}}

Plug 'Shougo/deol.nvim', { 'do': ':UpdateRemotePlugins' } "{{{
"}}}

Plug 'eugen0329/vim-esearch', {'branch': 'development'} "{{{
let g:esearch = {
            \ 'adapter':          'ag',
            \ 'bckend':          'nvim',
            \ 'out':              'win',
            \ 'batch_size':       1000,
            \ 'default_mappings': 1,
            \ 'live_update': 0,
            \}
nmap <leader>f <Plug>(operator-esearch-prefill)iw
vmap <leader>f <Plug>(esearch)
let g:esearch.default_mappings = 0
let g:esearch.win_map = [
            \ ['n', '<cr>', '<cmd>call b:esearch.open("NewTabdrop")<cr>'],
            \ ['n', 't',  '<cmd>call b:esearch.open("NETRTabdrop")<cr>'],
            \ ['n', 'pp', '<cmd>call b:esearch.split_preview_open() | wincmd W<cr>'],
            \ ['n', 'R', '<cmd>call b:esearch.reload({"backend": "system"})<cr>'],
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
let g:context_add_mappings=0
let g:context_enabled=0
nnoremap <m-i> :ContextPeek<cr>
"}}}
Plug 'embear/vim-localvimrc' "{{{
let g:localvimrc_ask = 0
"}}}
Plug 'mipmip/vim-scimark' "{{{
"}}}
Plug 'andymass/vim-matchup'
Plug 'AndrewRadev/linediff.vim'

Plug 'git@github.com:ipod825/vim-netranger' "{{{
let g:NETRRifleFile = $HOME."/dotfiles/config/nvim/settings/rifle.conf"
let g:NETRIgnore = ['__pycache__', '*.pyc', '*.o', 'egg-info', 'tags']
let g:NETRColors = {'dir': 39, 'footer': 35, 'exe': 35}
let g:NETRGuiColors = {'dir': '#00afff', 'footer': '#00af5f', 'exe': '#00af5f'}
let g:NETRDefaultMapSkip = ["L", "<cr>"]
let g:NETRVimCD = ["cd"]
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

silent doautocmd USER PLUGEND
