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
nmap <c-j> <cmd>call <sid>NextBlock()<cr>
nmap <c-k> <cmd>call <sid>PreviousBlock()<cr>
vnoremap <c-j> <cmd>call <sid>NextBlock()<cr>
vnoremap <c-k> <cmd>call <sid>PreviousBlock()<cr>
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
nnoremap <m-t> <cmd>call ReuseTerm('Tabdrop', getcwd())<cr>
nnoremap <m-o> <cmd>call ReuseTerm('split', getcwd())<cr>
nnoremap <m-e> <cmd>call ReuseTerm('vsplit', getcwd())<cr>
nnoremap <m-s-t> <cmd>call OpenTerm('Tabdrop')<cr>
nnoremap <m-s-o> <cmd>call OpenTerm('split')<cr>
nnoremap <m-s-e> <cmd>call OpenTerm('vsplit')<cr>
tnoremap jk <c-\><c-n>
tnoremap <m-j> <c-\><c-n><cmd>call ToggleTermNojk()<cr>i
tnoremap <m-k> <c-\><c-n>:ToggleTermInsert<cr>
tnoremap <c-a> <c-\><c-n><c-w>
tnoremap <c-z> <c-v><c-z>
tnoremap <c-k> <up>
tnoremap <c-j> <down>
"}}}

" Tab switching {{{
nnoremap <c-h> gT
nnoremap <c-l> gt
nnoremap <c-m-h> :tabmove -1<cr>
nnoremap <c-m-l> :tabmove +1<cr>
tmap <c-h> jkgT
tmap <c-l> jkgt
nnoremap <c-m-j> <c-\><c-n><cmd>call MoveToPrevTab()<cr>
nnoremap <c-m-k> <c-\><c-n><cmd>call MoveToNextTab()<cr>
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
cnoreabbrev sudow w !sudo -A tee % > /dev/null
cnoreabbrev man Man
cnoremap qq :bwipeout<cr>

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
vmap <m-y> <cmd>call <sid>YankToSystemClipboard()<cr>
" stay at the end after copy/paste
vnoremap y y`]
nnoremap p p`]
vnoremap p "_dP`]
" select last paste
nmap <m-p> V'[
"wrap long comment that is not automatically done by ale
nnoremap U <cmd>call CommentUnwrap()<cr>
" pressing dw is easier but de is more natural
" folding
nmap <leader><space> za
nmap <leader>z zMzvzz
" simple calculator
inoremap <c-c> <c-o>yiW<end>=<c-r>=<c-r>0<cr>
" shift
nnoremap > >>
nnoremap < <<
vnoremap > >gv
vnoremap < <gv
" }}}

" Diff {{{
nnoremap <leader>h <cmd>call DiffGet()<cr>
nnoremap <leader>l <cmd>call DiffPut()<cr>
vnoremap <leader>h :'<,'>call DiffGet()<cr>
vnoremap <leader>l :'<,'>call DiffPut()<cr>
function! DiffGet()
    if len(tabpagebuflist()) == 3
        for l:buf in tabpagebuflist()
           let l:bufname = bufname(l:buf)
           if l:bufname !~ "gina:"
               exec 'diffget '.l:bufname
           endif
        endfor
    else
        if winnr() == 1
            diffget
        else
            diffput
        endif
    endif
endfunction

function! DiffPut()
    if len(tabpagebuflist()) == 3
           diffget HEAD:
    else
        if winnr() == 2
            diffget
        else
            diffput
        endif
    endif
endfunction

" }}}

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
        else
            exec a:opencmd
            exec 'term ++close ++curwin ++kill=9'.$SHELL
        endif
        silent! normal! i
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

function! s:YankToSystemClipboard()
    let l:should_strip = &bt=='terminal' && mode() == 'V'
    normal! "+y
    if l:should_strip
        let w = winwidth(0)
        let res = split(@+, '\n')
        for i in range(len(res))
            if res[i]=~'^'.$USER || len(res[i])<w
                let res[i].=''
            endif
        endfor
        let @+=join(res, '')
    endif
endfunction

function! s:NextBlock()
    if &bt!='terminal'
        let ori_line = line('.')
        normal! }
        if line('.') == ori_line+1
            normal! }
        endif
        if line('.') != line('$')
            normal! k
        endif
    else
        call search('^'.$USER, 'Wz')
    endif
endfunction

function! s:PreviousBlock()
    if &bt!='terminal'
        let ori_line = line('.')
        normal! {
        if line('.') == ori_line-1
            normal! {
        endif
        if line('.') != 1
            normal! j
        endif
    else
        call search('^'.$USER, 'Wbz')
    endif
endfunction
