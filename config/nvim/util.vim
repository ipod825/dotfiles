let g:util_commands= []
function! AddUtilComand(cmd)
    if index(g:util_commands, a:cmd) < 0
        call insert(g:util_commands, a:cmd)
    endif
endfunction

" {{{ Current buffer search
nnoremap <silent> / :call SearchWord()<cr>
nnoremap ? /
function! s:Line_handler(l)
    let keys = split(a:l, ':')
    exec keys[0]
    call feedkeys('zz')
endfunction

function! SearchWord()
    let s:fzf_ft=&ft
    augroup FzfSearchWord
        autocmd!
    augroup END
    silent call fzf#run(fzf#wrap({
                \   'source':  map(getline(1, '$'), '(v:key + 1) . ": " . v:val '),
                \   'sink':    function('s:Line_handler'),
                \   'options': '+s -e --ansi',
                \}))
    let s:fzf_ft=''
endfunction
" }}}

" {{{ Open files from project root
function! _OpenFileFromProjectRoot()
    exec "Files " . FindRootDirectory()
endfunction
nnoremap <c-o> :call _OpenFileFromProjectRoot()<cr>
tnoremap <c-o> <c-\><c-n>:call _OpenFileFromProjectRoot()<cr>
" }}}

" {{{ Open config files
command! OpenConfigFiles :call fzf#run(fzf#wrap({
            \   'source':  systemlist('$HOME/dotfiles/misc/watchfiles.sh nvim'),
            \}))<cr>
nnoremap <silent><leader>e :OpenConfigFiles<cr>
" }}}

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
call AddUtilComand('SaveWithoutFix')

function! ClearSign()
    exe 'sign unplace * buffer='.bufnr()
endfunction
call AddUtilComand('ClearSign')

function! OpenRelatedFile()
    let name=expand('%:t:r')
    exec "Files " . FindRootDirectory()
    call feedkeys("i")
    call feedkeys(name)
endfunction
call AddUtilComand('OpenRelatedFile')

function! YankAbsPath()
    let @+=expand('%:p')
    let @"=expand('%:p')
endfunction
call AddUtilComand('YankAbsPath')

function! YankBaseName()
    let @+=expand('%:p:t')
    let @"=expand('%:p:t')
endfunction
call AddUtilComand('YankBaseName')

function! RemoveRedundantWhiteSpace()
    let l:save = winsaveview()

    if mode()=='v'
        '<,'>s/\(\S\)\s\+\(\S\)/\1 \2/g
    else
        %s/\(\S\)\s\+\(\S\)/\1 \2/g
    endif

    call winrestview(l:save)
endfunction
call AddUtilComand('RemoveRedundantWhiteSpace')
