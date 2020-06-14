let mapleader=' '
" Mode Changing {{{
nnoremap ; :
noremap! jk <Esc>
cnoremap <m-d> <c-f>dwi
onoremap jk <Esc>
vnoremap <cr> <Esc>
inoremap <c-a> <esc><c-w>
"}}}

" Moving Around {{{
nnoremap j gj
nnoremap k gk
nmap <c-j> }
nmap <c-k> {
vnoremap <c-j> }
vnoremap <c-k> {
noremap! <c-h> <Left>
noremap! <c-l> <Right>
noremap! <c-j> <Down>
noremap! <c-k> <Up>
nnoremap <cr> <c-w>w
"}}}

" Moving Around (home,END) {{{
onoremap <m-h> g^
onoremap <m-l> g$
vnoremap <m-h> g^
vnoremap <m-l> g$<left>
nnoremap <m-h> g^
nnoremap <m-l> g$
inoremap <m-h> <Esc>g^i
inoremap <m-l> <Esc>g_i
cnoremap <m-h> <c-b>
cnoremap <m-l> <c-e>
tnoremap <m-h> <home>
tnoremap <m-l> <end>
"}}}

" Terminal {{{
nnoremap <m-t> :call ReuseTerm('Tabdrop', getcwd())<cr>
nnoremap <m-o> :call ReuseTerm('split', getcwd())<cr>
nnoremap <m-e> :call ReuseTerm('vsplit', getcwd())<cr>
nnoremap <m-s-t> :call OpenTerm('Tabdrop')<cr>
nnoremap <m-s-o> :call OpenTerm('split')<cr>
nnoremap <m-s-e> :call OpenTerm('vsplit')<cr>
tnoremap jk <c-\><c-n>
tnoremap <m-j> <c-\><c-n>:call ToggleTermNojk()<cr>i
tnoremap <m-k> <c-\><c-n>:ToggleTermInsert<cr>
tnoremap <c-a> <c-\><c-n><c-w>
tnoremap <c-z> <c-v><c-z>
tnoremap <c-k> <up>
tnoremap <c-j> <down>
"}}}

" Tab switching {{{
nnoremap <c-h> gT
nnoremap <c-l> gt
tnoremap <c-h> <c-\><c-n>gT
tnoremap <c-l> <c-\><c-n>gt
nnoremap <c-m-h> :tabm -1<cr>
nnoremap <c-m-l> :tabm +1<cr>
nnoremap <c-m-j> <c-\><c-n>:call MoveToPrevTab()<cr>
nnoremap <c-m-k> <c-\><c-n>:call MoveToNextTab()<cr>
" }}}

" Window {{{
nnoremap <c-a> <c-w>
inoremap <c-a> <Esc><c-w>
nnoremap <c-m-down> <c-w>+
nnoremap <c-m-up> <c-w>-
nnoremap <c-m-left> <c-w><
nnoremap <c-m-right> <c-w>>
nnoremap q :quit<cr>
nnoremap Q q
" }}}

" aliasing {{{
cnoreabbrev help tab help
cnoreabbrev te Tabdrop
cnoreabbrev tc tabclose
let $SUDO_ASKPASS="/usr/bin/ssh-askpass"
cnoreabbrev sudow w !sudo -A tee %
cnoreabbrev man Man
cnoremap qq :call Bwipeout()<cr>
" }}}

" searching {{{
"clear search highlight
nnoremap <silent><leader>/ :let @/=""<cr>
" centerized after jump
nnoremap * *Nm'zz
" }}}

" misc {{{
"paste yanked text in command line
cnoremap <m-p> <c-r>"
"paste current file name in command line
cnoremap <m-f> <c-r>%<c-f>
"yank to system clipboard
vnoremap <m-y> "+y
"wrap long comment that is not automatically done by ale
nnoremap U :call CommentUnwrap()<cr>
" pressing dw is easier but de is more natural
onoremap w :call EndOfWord()<cr>
" folding
nmap <leader><space> za
vnoremap <space> zf
" }}}

" Diff {{{
nnoremap <leader>h :call DiffGet()<cr>
nnoremap <leader>l :call DiffPut()<cr>
vnoremap <leader>h :'<,'>call DiffGet()<cr>
vnoremap <leader>l :'<,'>call DiffPut()<cr>
function! DiffGet()
    if len(tabpagebuflist()) == 3
        diffget //3
        return
    endif

    if winnr() == 1
        diffget
    else
        diffput
    endif
endfunction

function! DiffPut()
    if len(tabpagebuflist()) == 3
        diffget //2
        return
    endif

    if winnr() == 2
        diffget
    else
        diffput
    endif
endfunction

" }}}

function! EndOfWord()
    let cur_line = getline('.')
    if match(cur_line[col('.')-1], ' ') > -1
        normal! w
    else
        normal! el
    endif
endfunction

function! MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    vsp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    vsp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! OpenTerm(opencmd, ...)
    if a:0 > 0
        exec a:opencmd.' '.a:1
    else
        if has('nvim')
            exec a:opencmd
            term
            startinsert
        else
            exec a:opencmd
            exec 'term ++close ++curwin '.$SHELL
        endif
    endif
endfunction

let s:reused_term_fname = get(s:, 'reused_term_fname', {})
function! ReuseTerm(opencmd, ...)
    let l:name = a:0>0? a:1 : 'default'

    if !has_key(s:reused_term_fname, l:name)
        call OpenTerm(a:opencmd)
        let s:reused_term_fname[l:name] = expand('%:p')
        exec 'autocmd BufUnload <buffer> unlet s:reused_term_fname["'.l:name.'"]'
        tnoremap <buffer> <c-d> <c-\><c-n>:quit<cr>
        nnoremap <buffer> q :quit<cr>
        return v:false
    else
        call OpenTerm(a:opencmd, s:reused_term_fname[l:name])
        return v:true
    endif
endfunction


let s:nojkbuf = {}
augroup TERMNOJK
    autocmd!
    autocmd BufEnter * if has_key(s:nojkbuf, bufnr("%"))  | set timeoutlen=10 | endif
    autocmd BufLeave * if has_key(s:nojkbuf, bufnr("%"))  | set timeoutlen=500 | endif
augroup END
function! ToggleTermNojk()
    if has_key(s:nojkbuf, bufnr("%"))
        call remove(s:nojkbuf, bufnr("%"))
        set timeoutlen=500
        tunmap <buffer> ;
    else
        set timeoutlen=10
        let s:nojkbuf[bufnr("%")] = 1
        tnoremap <buffer> ; <C-\><C-n>:
    endif
endfunction

function! CommentUnwrap()
    if &ft=="python"
        set textwidth=79
    else
        set textwidth=80
    endif
    normal! vgq
    set textwidth=0
endfunction

function! s:ShowInfo()
    echo '⚓'.tagbar#currenttag("%s", "", "f")
endfunction
