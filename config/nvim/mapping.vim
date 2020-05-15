let mapleader=' '
" Mode Changing {{{
nnoremap ; :
inoremap jk <Esc>
cnoremap jk <Esc>
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
inoremap <c-h> <Left>
inoremap <c-l> <Right>
inoremap <c-j> <Down>
inoremap <c-k> <Up>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>
cnoremap <c-j> <Down>
cnoremap <c-k> <Up>
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
if has('nvim')
    nnoremap <m-t> :exec 'tabe term://'.$SHELL<cr>
    nnoremap <m-o> :exec 'new term://'.$SHELL<cr>
    nnoremap <m-e> :exec 'vnew term://'.$SHELL<cr>
    nnoremap <m-r> :call ReuseTerm()<cr>
    tnoremap <m-r> <c-\><c-n>:call ReuseTerm()<cr>
else
    nnoremap <m-t> :tabe<cr>:term ++curwin ++close zsh<cr>
    nnoremap <m-o> :term ++close zsh<cr>
    nnoremap <m-e> :vertical term ++close zsh<cr>
endif
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
cnoreabbrev gps G push
cnoreabbrev gpl G pull
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

function! Bwipeout()
    if bufname('#')!=''
        bwipeout
    else
        close
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

let s:reused_term_buf = get(s:, 'reused_term_buf', 0)
function! ReuseTerm()
    if s:reused_term_buf>0
        if bufnr() == s:reused_term_buf
            quit
        else
            execute s:reused_term_buf.'sb'
            wincmd J
        endif
    else
        exec 'new term://'.$SHELL
        wincmd J
        let s:reused_term_buf = bufnr()
        autocmd BufUnload <buffer> let s:reused_term_buf=0
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
