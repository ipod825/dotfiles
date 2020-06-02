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

function! s:ExecFnOrCmd(name) "{{{
    if exists(":".a:name)
        execute a:name
    elseif exists('*<sid>'.a:name)
        execute 'call <sid>'.a:name.'()'
    elseif exists('*'.a:name)
        execute 'call '.a:name.'()'
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
    let tracked = s:UniqueList(systemlist('git for-each-ref --format="%(upstream:short)" '.refs))
    silent call fzf#run(fzf#wrap({
                \ 'source': extend(locals, tracked),
                \ 'sink': '!git checkout '
                \}))
endfunction
"}}}
cnoreabbrev gcb call <sid>GitCheckBranch()


function! s:SearchWordExact() "{{{
    silent call fzf#run(fzf#wrap({
                \ 'source': map(getline(1, '$'), '(v:key + 1) . ": " . v:val '),
                \ 'sink': function('s:Line_handler'),
                \ 'options': '+s -e --ansi',
                \}))
endfunction
function! s:SearchWord() "{{{
    silent call fzf#run(fzf#wrap({
                \ 'source': map(getline(1, '$'), '(v:key + 1) . ": " . v:val '),
                \ 'sink': function('s:Line_handler'),
                \ 'options': '+s --ansi --algo=v1',
                \}))
endfunction
function! s:Line_handler(l)
    let keys = split(a:l, ':')
    exec keys[0]
endfunction
"}}}
call s:MapUtil('/', 'SearchWordExact')
call s:MapUtil('<m-/>', 'SearchWord')

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
    exec "'<,'>s/\(\S\)\s\+\(\S\)/\1 \2/g"    "{{{
endfunction
call AddUtilComand('VRemoveRedundantWhiteSpace')

function! RemoveRedundantWhiteSpace()     "{{{
    let l:save = winsaveview()
    %s/\(\S\)\s\+\(\S\)/\1 \2/g
    call winrestview(l:save)
endfunction
"}}}
call AddUtilComand('RemoveRedundantWhiteSpace')
