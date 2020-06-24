let g:util_commands= []
function! AddUtilComand(cmd)
    if index(g:util_commands, a:cmd) < 0
        call insert(g:util_commands, a:cmd)
    endif
endfunction

nnoremap <silent><leader><cr> :call fzf#run(fzf#wrap({
            \ 'source': sort(g:util_commands),
            \ 'sink': function('<sid>ExecFnOrCmd'),
            \}))<cr>
vnoremap <silent><leader><cr> :<c-u>call fzf#run(fzf#wrap({
            \ 'source': sort(g:util_commands),
            \ 'sink': function('<sid>ExecFnOrCmd'),
            \}))<cr>

" using timer_start because if ExecFnOrCmd executed within fzf#run, there's
" sometimes some problems.
let s:execname = ''
function! s:ExecFnOrCmd(name) "{{{
    let s:execname = a:name
    call timer_start(0, function('s:ExecFnOrCmdImpl'))
endfunction
function! s:ExecFnOrCmdImpl(t) "{{{
    if exists(":".s:execname)
        execute s:execname
    elseif exists('*<sid>'.s:execname)
        execute 'call <sid>'.s:execname.'()'
    elseif exists('*'.s:execname)
        execute 'call '.s:execname.'()'
    endif
endfunction
"}}}

function! s:MapUtil(mapping, cmd) "{{{
    if exists('*<sid>'.a:cmd)
        let cmd = ':call <sid>'.a:cmd.'()<cr>'
    else
        let cmd = a:cmd
    endif
    exec 'nnoremap '.a:mapping.' '.cmd
endfunction
"}}}

function! s:UniqueList(lst)
    let res = {}
    for i in a:lst
        let res[i] = 0
    endfor
    return keys(res)
endfunction

function! s:GitBranchDelete() "{{{
    let locals = map(systemlist('git branch'), {i,b->b[2:]})
    silent call fzf#run(fzf#wrap({
                \ 'source': locals,
                \ 'sink': '!git branch -D '
                \}))
endfunction
"}}}
cnoreabbrev gbd call <sid>GitBranchDelete()

function! s:GitCheckBranch() "{{{
    let locals = map(systemlist('git branch'), {i,b->b[2:]})
    let refs = join(map(copy(locals), {i,b->'refs/heads/'.b}), ' ')
    let tracked = s:UniqueList(filter(systemlist('git for-each-ref --format="%(upstream:short)" '.refs), "!empty(v:val)"))
    silent call fzf#run(fzf#wrap({
                \ 'source': extend(locals, tracked),
                \ 'sink': '!git checkout '
                \}))
endfunction
"}}}
cnoreabbrev gcb call <sid>GitCheckBranch()


function! s:SearchWord() "{{{
    silent call fzf#run(fzf#wrap({
                \ 'source': map(getline(1, '$'), '(v:key + 1) . ": " . v:val '),
                \ 'sink': function('s:Line_handler'),
                \ 'options': '+s -e --ansi',
                \}))
endfunction
function! s:Line_handler(l)
    let keys = split(a:l, ':')
    exec keys[0]
endfunction
"}}}
call s:MapUtil('/', 'SearchWord')

function! s:OpenFileFromProjectRoot() "{{{
    exec "Files " . FindRootDirectory()
endfunction
call s:MapUtil('<c-o>', 'OpenFileFromProjectRoot')
"}}}

function! s:OpenConfigFiles() "{{{
    call fzf#run(fzf#wrap({
                \ 'source': systemlist('$HOME/dotfiles/misc/watchfiles.sh nvim'),
                \}))
endfunction
call s:MapUtil('<leader>e', 'OpenConfigFiles')
"}}}

function! s:OpenRecentFile() "{{{
    silent call fzf#run(fzf#wrap({
                \ 'source': filter(filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|term\\|^/tmp/\\|.git/\\|Search ‹'"), " isdirectory(v:val) || filereadable(v:val)"),
                \ 'options': '+s --history-size=30 --history='.$HOME.'/.cache/fzf-mru',
                \}))
endfunction
"}}}
cnoreabbrev f call <sid>OpenRecentFile()

function! s:ToggleSaveWithoutFix() "{{{
    let b:ale_fix_on_save = 1 - get(b:, "ale_fix_on_save", 1)
    write
endfunction
"}}}
call AddUtilComand('ToggleSaveWithoutFix')

function! s:ClearSign() "{{{
    exe 'sign unplace * buffer='.bufnr()
endfunction
"}}}
call AddUtilComand('ClearSign')

function! s:OpenRelatedFile() "{{{
    let name=expand('%:t:r')
    exec "Files " . FindRootDirectory()
    call feedkeys("i")
    call feedkeys(name)
endfunction
"}}}
call AddUtilComand('OpenRelatedFile')

function! s:YankAbsPath() "{{{
    let @+=expand('%:p')
    let @"=expand('%:p')
endfunction
"}}}
call AddUtilComand('YankAbsPath')

function! s:YankBaseName() "{{{
    let @+=expand('%:p:t')
    let @"=expand('%:p:t')
endfunction
"}}}
call AddUtilComand('YankBaseName')
function! VRemoveRedundantWhiteSpace()     "{{{
    exec "'<,'>s/\(\S\)\s\+\(\S\)/\1 \2/g"
endfunction
call AddUtilComand('VRemoveRedundantWhiteSpace')

function! RemoveRedundantWhiteSpace()     "{{{
    let l:save = winsaveview()
    %s/\(\S\)\s\+\(\S\)/\1 \2/g
    call winrestview(l:save)
endfunction
"}}}
call AddUtilComand('RemoveRedundantWhiteSpace')
