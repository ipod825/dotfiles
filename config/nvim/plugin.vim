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
let g:my_colorscheme='one'
let g:one_allow_italics = 1
augrou ONE
    autocmd!
    autocmd ColorScheme * call one#highlight("CursorLine", '', '2e5057', 'bold')
    autocmd ColorScheme * call one#highlight("Visual", '', '054d5c', '')
    autocmd ColorScheme * call one#highlight("Comment", '7c7d7d', '', '')
    autocmd ColorScheme * hi VertSplit ctermbg=NONE guibg=NONE
augrou END
"}}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' "{{{
autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
autocmd VimEnter * command! -bang -nargs=? Buffers call fzf#vim#buffers(<q-args>, {'options': '--no-preview'}, <bang>0)
let g:fzf_layout = {'up': '100%'}
let g:fzf_action = {'ctrl-e': 'edit', 'Enter': 'Tabdrop', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_ft=''
augroup FZF
    autocmd!
    autocmd! FileType fzf if strlen(g:fzf_ft)  && g:fzf_ft!= "man" | silent! let &ft=g:fzf_ft | endif
augroup END
"}}}

Plug 'wsdjeg/vim-fetch'
Plug 'git@github.com:ipod825/vim-tabdrop'

Plug 'lambdalisue/gina.vim' "{{{
let g:gina#action#index#discard_directories=1
cnoreabbrev G Gina status -s
cnoreabbrev gbr Gina branch
cnoreabbrev glg Gina log --branches --graph
cnoreabbrev glc exec "Gina log --branches --graph -- ".expand("%:p")
cnoreabbrev gps Gina push
cnoreabbrev gpl Gina pull
cnoreabbrev grc Gina!! rebase --continue
cnoreabbrev gra Gina!! rebase --abort
augroup GINA
    autocmd!
    autocmd VimEnter * call s:SetupGina()
    autocmd Filetype gina-log call matchadd('ErrorMsg', '.*HEAD.*')
    autocmd Filetype gina-status,gina-log,gina-branch,diff silent! tabmove -1 | exec 'lcd '.system('git rev-parse --show-toplevel')
augroup END

function! GitNavigate(back)
    if a:back
        call search('^diff', 'Wb')
    else
        call search('^diff', 'W')
    endif
    normal! zMzvzt
endfunction

augroup GIT
    autocmd!
    autocmd Filetype git nnoremap <buffer> cc <cmd>call <sid>GitCheckOutFile()<cr><cr>
    autocmd Filetype git nnoremap <buffer> <cr> <c-w>v<cmd>call gina#core#diffjump#jump()<cr>
    autocmd Filetype git exec 'lcd '.system('git rev-parse --show-toplevel')
    autocmd Filetype git setlocal foldmethod=syntax
    autocmd Filetype git nnoremap <buffer> <c-j> <cmd>call GitNavigate(v:false)<cr>
    autocmd Filetype git nnoremap <buffer> <c-k> <cmd>call GitNavigate(v:true)<cr>
    autocmd Filetype git setlocal scrolloff=0
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
try
	call gina#custom#command#option('/\%(diff\|commit\|status\|branch\|log\)', '--opener', 'tabedit')
	call gina#custom#command#option('/\%(changes\)', '--opener', 'vsplit')
	call gina#custom#mapping#nmap('/.*', '<F1>','<Plug>(gina-builtin-help)')
    call gina#custom#mapping#nmap('/.*', '?','<Plug>MSAddBySearchForward')
	call gina#custom#mapping#nmap('status', '<cr>','<Plug>(gina-edit)')
	call gina#custom#mapping#nmap('status', '-','<Plug>(gina-index-toggle)j', {'nowait': v:true})
	call gina#custom#mapping#vmap('status', '-','<Plug>(gina-index-toggle)', {'nowait': v:true})
	call gina#custom#mapping#nmap('status', 'X','<Plug>(gina-index-discard-force)')
	call gina#custom#mapping#vmap('status', 'X','<Plug>(gina-index-discard-force)')
	call gina#custom#mapping#nmap('status', 'H','<Plug>(gina-index-stage)j')
	call gina#custom#mapping#vmap('status', 'H','<Plug>(gina-index-stage)')
	call gina#custom#mapping#nmap('status', 'L','<Plug>(gina-index-unstage)j')
	call gina#custom#mapping#vmap('status', 'L','<Plug>(gina-index-unstage)')
	call gina#custom#mapping#nmap('status', 'dd','<Plug>(gina-diff-tab)')
	call gina#custom#mapping#nmap('status', 'ds','<cmd>call GinaCompare()<cr>')
	call gina#custom#mapping#nmap('status', 'DD','<cmd>call GinaStatusPatch()<cr>')
	call gina#custom#mapping#nmap('status', 'cc','<cmd>call GinaCommit()<cr>')
	call gina#custom#mapping#nmap('status', 'ca','<cmd>call GinaCommit("--amend --allow-empty")<cr>')
    call gina#custom#mapping#nmap('log', '<cr>','<Plug>(gina-show-vsplit)')
    call gina#custom#mapping#nmap('log', 'dd','<Plug>(gina-show-tab)')
    call gina#custom#mapping#nmap('log', 'DD','<Plug>(gina-changes-between)')
    call gina#custom#mapping#nmap('log', '<m-w>',':set wrap!<cr>')
    call gina#custom#mapping#nmap('log', 'cc','<cmd>call GinaLogCheckout()<cr>')
    call gina#custom#mapping#nmap('log', 'cb','<cmd>call GinaLogCheckoutNewBranch()<cr>')
    call gina#custom#mapping#nmap('log', 'r','<cmd>call GinaLogRebase()<cr>')
    call gina#custom#mapping#vmap('log', 'r',':<c-u>call GinaLogRebaseOnto()<cr>')
    call gina#custom#mapping#nmap('log', 'm','<cmd>call GinaLogMarkTarget()<cr>')
    call gina#custom#mapping#nmap('log', '<m-s-d>','<cmd>call GinaLogDeleteBranch()<cr>', {'silent': 1})
    call gina#custom#mapping#nmap('changes', '<cr>','<Plug>(gina-diff-tab)')
    call gina#custom#mapping#nmap('changes', 'dd','<Plug>(gina-diff-tab)')
    call gina#custom#mapping#nmap('changes', 'DD','<Plug>(gina-compare-vsplit)')
    call gina#custom#mapping#nmap('branch', '<m-n>','<Plug>(gina-branch-new)')
    call gina#custom#mapping#nmap('branch', '<m-d>','<Plug>(gina-branch-delete)')
    call gina#custom#mapping#nmap('branch', '<m-s-d>','<Plug>(gina-branch-delete-force)')
    call gina#custom#mapping#nmap('branch', '<m-m>','<Plug>(gina-branch-move)')
    call gina#custom#mapping#nmap('branch', 'T','<Plug>(gina-branch-set-upstream-to)')
    call gina#custom#mapping#nmap('branch', 'dd','<Plug>(gina-show-commit-vsplit)')
    call gina#custom#mapping#nmap('branch', 'DD','<Plug>(gina-changes-between)')
    call gina#custom#mapping#nmap('branch', 'r','<Plug>(gina-commit-rebase)')
    call gina#custom#mapping#nmap('branch', 'm','<cmd>call GinaBranchMarkTarget()<cr>')
    call gina#custom#mapping#vmap('branch', 'r','<cmd>call GinaBranchRebaseOnto()<cr>')
catch E117:
endtry
endfunction

function! GitInfo() abort
try
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
catch E117:
endtry
endfunction


function! GinaCompare()
    call gina#action#call('compare:tab')
    silent! tabmove -1
endfunction

function! GinaCommit(...)
    quit
    execute 'Gina commit '.join(a:000,'')
    silent! tabmove -1
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

function! GinaStatusPatch()
    let l:line = substitute(getline('.'), '[\d*m', '', 'g')
    if l:line[:1] == "MM"
        call gina#action#call('patch:tab')
    elseif l:line[:1] == "UU"
        call gina#action#call('chaperon:tab')
    else
        call gina#action#call('patch:tab')
    endif
    silent! tabmove -1
    wincmd K
endfunction

function! GinaBranchRebaseOnto()
    let l:target_branch = get(w:, 'target_branch', '')
    if empty(l:target_branch)
        echoerr "No target branch"
    endif

    let line_start = getpos("v")[1]
    let line_end = getpos(".")[1]
    let l:branches = []
    for l:line_nr in range(line_start,line_end)
        call add(l:branches, GinaBranchGetBranch(l:line_nr))
    endfor

    let l:branches = [l:target_branch] + l:branches
    let l:ori_branch = system('git branch --show-current')
    for l:i in range(len(l:branches)-1)
        let l:target = l:branches[0]
        let l:source = l:branches[1]
        call remove(l:branches, 0)
        exec 'silent !git checkout '.l:source
        if system('git rebase --onto '.l:target.' HEAD~1') =~ 'CONFLICT'
            echoerr 'Conflict when rebasing '.l:source.' to '.l:target.'. Fix it before continue.'
            edit
            return
        endif
    endfor
    exec 'silent !git checkout '.l:ori_branch
    edit
endfunction

function! s:GinaLogRefreshFzfCmd(cmd)
    return {arg-> execute(a:cmd.' '.arg) || timer_start(150, {_->execute('edit')})}
endfunction

function! s:GinaLogRefresh()
    edit
    if get(w:, 'mark_id', -1) >=0
        call matchdelete(w:mark_id)
        let w:mark_id = matchadd('RedrawDebugRecompose', w:target_branch)
    endif
endfunction

function! GinaBranchGetBranch(line_nr)
    let l:line_nr = a:line_nr
    if l:line_nr == '.'
        let l:line_nr = line(a:line_nr)
    endif
    let l:line = getline(l:line_nr)
    if l:line =~ '[32m'
        let l:line = l:line[7:-4]
    else
        let l:line = l:line[2:-4]
    endif
    if !empty(matchstr(l:line, '[0-9a-f]\{6,9\}'))
        let l:line = matchstr(l:line, '[0-9a-f]\{6,9\}')
    endif
    return l:line
endfunction

function! s:GinaLogGetBranches(line_nr)
    let l:line_nr = a:line_nr
    if l:line_nr == '.'
        let l:line_nr = line(a:line_nr)
    endif
    let l:branch_str = matchstr(getline(l:line_nr), ';1m ([^)]*)')[4:]
    if !empty(l:branch_str)
        let l:branches = split(l:branch_str[1:len(l:branch_str)-2], ', ')
        return filter(map(l:branches, function('<sid>BranchFilter')), '!empty(v:val)')
    endif
    return []
endfunction

function! GinaLogCandidate()
    return s:GinaLogGetBranches(line('.')) + [GinaLogHash('.')]
endfunction

function! GinaLogHash(lineno)
    return matchstr(getline(a:lineno), '[0-9a-f]\{6,9\}')
endfunction

function! GinaBranchMarkTarget()
    let w:target_branch = GinaBranchGetBranch(".")
    if get(w:, 'mark_id', -1) >=0
        call matchdelete(w:mark_id)
    endif
    let w:mark_id = matchaddpos('RedrawDebugRecompose', [line('.')])
endfunction

function! GinaLogMarkTarget()
    let w:target_branch =GinaLogCandidate()[-1]
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

function! GinaLogRebaseOnto()
    let l:target_branch = get(w:, 'target_branch', '')
    if empty(l:target_branch)
        echoerr "No target branch!"
        return
    endif

    let [line_start,line_end] = [getpos("'<")[1], getpos("'>")[1]]
    let l:brs = s:GinaLogGetBranches(l:line_start)
    if len(l:brs)==0
        let l:beg_hash = GinaLogHash(l:line_start)
        call insert(l:brs, input("No branches for ".l:beg_hash.". Please specify new branch:"))
        if len(l:brs) == 0
            return
        endif
    endif

    let l:branches = [l:brs[0]]
    for l:line_nr in range(line_start+1,line_end)
        let l:brs = s:GinaLogGetBranches(l:line_nr)
        let l:hash = GinaLogHash(l:line_nr)
        if empty(l:hash)
            continue
        endif
        if len(l:brs)==0
            let l:tmp_branch_name = 'rebase-'.l:hash
            exec 'silent !git branch '.l:tmp_branch_name.' '.l:hash
            call add(l:branches, l:tmp_branch_name)
        else
            call add(l:branches, l:brs[0])
        endif
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
        if l:target=~'rebase-'
            exec 'silent !git branch -d '.l:target
        endif
    endfor
    exec 'silent !git checkout '.l:ori_branch
    call s:GinaLogRefresh()
endfunction

function! GinaLogCheckout()
    call fzf#run(fzf#wrap({
            \ 'source': GinaLogCandidate(),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina checkout'),
            \ 'options': '+s -1',
        \}))
endfunction

function! GinaLogCheckoutNewBranch()
    let l:nb = input('New branch name: ')
    call fzf#run(fzf#wrap({
            \ 'source': GinaLogCandidate(),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina checkout -b '.l:nb),
            \ 'options': '+s -1',
        \}))
    call s:GinaLogRefresh()
endfunction

function! GinaLogRebase()
    call fzf#run(fzf#wrap({
            \ 'source': GinaLogCandidate(),
            \ 'sink': s:GinaLogRefreshFzfCmd('Gina!! rebase -i '),
            \ 'options': '+s -1',
        \}))
endfunction

function! GinaLogReset(opt)
    exec 'Gina reset 'a:opt.' '.GinaLogCandidate()[0]
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

Plug 'drmikehenry/vim-headerguard' "{{{
"}}}

Plug 'tpope/vim-abolish' "{{{
function! s:AbolishHandle(l)
    call timer_start(0, {_->execute('normal cr'.split(a:l, ':')[1])})
endfunction
function! DoAbolish()     "{{{
    call fzf#run(fzf#wrap({
                \ 'source': ['camelCase:c','MixedCase:m','snake_case:s','SNAKE_UPPERCASE:u'],
                \ 'sink': function('s:AbolishHandle')
                \}))
endfunction
call AddUtilComand('DoAbolish')
"}}}

" Plug 'cohama/lexima.vim' "{{{
" inoremap <m-e> <esc><cmd>call <sid>AutoPairsJump()<cr>
" function! s:AutoPairsJump()
"     normal! l
"     let l:b = getline('.')[col('.')+1]
"     normal! dl
"     if match(l:b, "[\"' ]")  == -1
"         call feedkeys('e')
"     endif
"     call feedkeys('pi')
" endfunction
" "}}}

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
let g:VM_maps['Case Conversion Menu'] = '<leader>c'
let g:VM_maps['Numbers'] = '<leader>n'
let g:VM_maps['Visual Add'] = '<c-n>'
let g:VM_maps['Visual Find'] = '<c-n>'
let g:VM_maps['Visual Regex'] = '<leader>/'
let g:VM_maps['Visual Cursors'] = '<c-i>'
let g:VM_maps["Visual Reduce"] = '<leader>r'
let g:VM_maps["Add Cursor At Pos"] = '<c-i>'
let g:VM_maps['Increase'] = '+'
let g:VM_maps['Decrease'] = '-'
let g:VM_maps['Exit'] = '<Esc>'

let g:VM_custom_motions  = {'<m-h>': '^', '<m-l>': '$'}
let g:VM_custom_noremaps  = {'])': '])', ']]': ']]', ']}':']}', 'w':'e'}

fun! VM_Start()
    let @"=''
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
    nmap <buffer> <c-c> <Esc>
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
    nunmap <buffer> <c-c>
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

nnoremap <leader>r <cmd>call <sid>SelectAllMark()<cr>
vnoremap <leader>r :<c-u>call <sid>VSelectAllMark()<cr>
"}}}

Plug 'git@github.com:ipod825/julia-unicode.vim', {'for': 'julia'}
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } " align code - helpful for latex table  {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}

Plug 'farmergreg/vim-lastplace'
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
            \ 'go': ['gopls'],
            \ 'rust': ['rls'],
            \ }
function! s:Gotodef()
    TabdropPushTag
    try
        TagTabdrop
    catch /E433:\|E426:/
        call LanguageClient_textDocument_definition({'gotoCmd': 'Tabdrop'})
    endtry
endfunction
nnoremap <m-d> <cmd>call <sid>Gotodef()<cr>
nmap <m-s> :TabdropPopTag<cr><esc>
nmap <silent>LH <Plug>(lcn-hover)
nmap <silent>LC <Plug>(lcn-menu)
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

Plug 'mhartington/formatter.nvim' "{{{
augroup FORMATTER
    autocmd!
    autocmd BufwritePre * FormatWrite
    autocmd USER PlugEnd call SetupFormatter()
augroup END
function! SetupFormatter()
lua << EOF
local prettier=function()
  return {
    exe = 'prettier',
    args = {'--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote'},
    stdin = true
  }
end
local isort = function()
    return {exe = 'isort', args = {'-', '--quiet'}, stdin = true}
end
local yapf = function()
    return {exe = 'yapf', stdin = true}
end
local rustfmt = function()
    return {exe = 'rustfmt', args = {'--emit=stdout'}, stdin = true}
end
local latexindent = function ()
  return {exe = 'latexindent', args = {'-sl', '-g /dev/stderr', '2>/dev/null'}, stdin = true}
end
local clang_format=function ()
  return {exe = 'clang-format', args = {'-assume-filename=' .. vim.fn.expand('%:t')}, stdin = true}
end
local lua_format = function ()
    return {exe = 'lua-format', stdin = true}
end
require('formatter').setup{
  logging = false,
  filetype = {
    javascript = {prettier},
    json = {prettier},
    html = {prettier},
    rust = {rustfmt},
    python = {isort, yapf},
    tex = {latexindent},
    c = {clang_format},
    cpp = {clang_format},
    lua = {lua_format}
  }
}
EOF
endfunction
" }}}


" if has('nvim') "{{{
"     Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins' }
" endif
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_ignore_case = 0
" if !exists('g:deoplete#omni_patterns')
"     let g:deoplete#omni_patterns = {}
" endif
" "}}}

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
let g:polyglot_disabled = ['sensible']
let g:polyglot_disabled = ['autoindent']
"}}}

Plug 'SirVer/ultisnips' "{{{
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetDirectories=[g:vim_dir.'snippets/UltiSnips']
"}}}


Plug 'rhysd/vim-grammarous', {'on': 'GrammarousCheck'}

Plug 'puremourning/vimspector' "{{{
"}}}

Plug 'luochen1990/rainbow', {'for': 'rust'} "{{{
let g:rainbow_active = 1
let g:rainbow_conf = {'ctermfgs': ['1', '2', '3', '6']}
"}}}
Plug 'Shougo/echodoc.vim'
" echodoc {{{
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'floating'
" }}}

Plug 'git@github.com:ipod825/war.vim' "{{{
augroup WAR
    autocmd!
    autocmd Filetype qf call war#fire(-1, 0.7, -1, 0.3)
    autocmd Filetype fugitive call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-status call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-commit call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-stash-show call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-log call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-branch call war#fire(-1, 1, -1, 0)
    autocmd Filetype gina-changes call war#fire(1, 1, 0, 0)
    autocmd Filetype git call war#fire(-1, 0.8, -1, 0.1)
    autocmd Filetype esearch call war#fire(0.8, -1, 0.2, -1)
    autocmd Filetype bookmark call war#fire(-1, 1, -1, 0.2)
    autocmd Filetype bookmark call war#enter(-1)
augroup END
" }}}

" if has("nvim") "{{{
if v:false "{{{
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
function! s:setup_treesitter()
try
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
catch
endtry
endfunction

augroup NVIMTREESITTER
    autocmd!
    autocmd VimEnter * call <sid>setup_treesitter()
augroup END
else
    set foldmethod=syntax
endif
augroup NVIMTREESITTER
    autocmd!
    autocmd Filetype python setlocal foldmethod=indent
augroup END
""}}}

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
Plug 'sgur/vim-textobj-parameter'
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
    autocmd Filetype bookmark nmap <buffer> <c-t> <cmd>call bookmark#open('Tabdrop')<cr>
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
                \ 'source': filter(map(copy(yoink#getYankHistory()),"v:val.text"), "len(v:val)>1"),
                \ 'sink': function('SelectYankHandler'),
                \}))
    let g:fzf_ft=''
endfunction
call AddUtilComand('SelectYank')
"}}}

Plug 'eugen0329/vim-esearch', {'branch': 'development'} "{{{
let g:esearch = {
            \ 'adapter':          'rg',
            \ 'bckend':          'nvim',
            \ 'out':              'win',
            \ 'batch_size':       1000,
            \ 'default_mappings': 1,
            \ 'live_update': 0,
            \ 'win_ui_nvim_syntax': 1,
            \ 'remember':  ['case', 'regex', 'filetypes', 'before', 'after', 'context'],
            \}
nmap <leader>f <Plug>(operator-esearch-prefill)iw
vmap <leader>f <Plug>(esearch)
nmap <leader>F <cmd>call esearch#init({'prefill':['cword'], 'paths': expand('%:p')})<cr>
vmap <expr><leader>F esearch#prefill({'paths': expand('%:p')})
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
    autocmd Filetype esearch silent! tabmove -1
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
let g:NETRRifleDisplayError = v:false
let g:NETRDefaultMapSkip = ['<cr>']
function! DuplicateNode()
    let path = netranger#api#cur_node_path()
    if isdirectory(path)
        let dir = fnamemodify(path, ':p:h:h')
        let newname = 'DUP'.fnamemodify(path[:-1], ':t')
    else
        let dir = fnamemodify(path, ':p:h')
        let newname = 'DUP'.fnamemodify(path, ':p:t')
    endif
    echom dir
    call netranger#api#cp(path, dir.'/'.newname)
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
" Plug 'git@github.com:ipod825/netranger-git' "{{{
"}}}

call plug#end()

doautocmd User PlugEnd
