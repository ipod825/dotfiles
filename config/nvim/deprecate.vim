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
" function! GitBranch()
"     let res = fugitive#head()
"     if empty(res)
"         let res = system('git rev-parse HEAD')[:5]
"     endif
"     return "⎇ ".res
" endfunction
" function! FugitiveObj()
"     let res = expand('%:p')
"     let ind = match(res, '.git//')
"     if ind<0
"         return ''
"     endif
"     let res = res[ind+6:]
"     let ind = match(res, '/')
"     return "⎇ ".res[:min([5, ind-1])]
" endfunction
""}}}
"Plug 'luochen1990/rainbow' "{{{
"let g:rainbow_active = 0
"let g:rainbow_conf = {'ctermfgs': ['1', '2', '3', '6']}
""}}}
" Plug 'Shougo/neco-vim'
" if exists('*nvim_open_win')
"     Plug 'ncm2/float-preview.nvim'
" endif
"Plug 'mbbill/undotree' "{{{
"if has("persistent_undo")
"    execute "set undodir=".g:vim_dir."undo/"
"    set undofile
"endif
""}}}
" Plug 'rhysd/vim-grammarous'
" Plug 'Yggdroot/LeaderF', { 'do': '.\install.sh' }
" Plug 'ipod825/fzf-mru.vim'
" function! s:Fzfmru() "{{{
"     silent call fzf#run(fzf#wrap({
"                 \ 'source': mru#list(),
"                 \}))
" endfunction
" cnoreabbrev f FZFMru

" Plug 'MattesGroeger/vim-bookmarks'
" Plug g:vim_dir.'bundle/vim-bookmark'
" let g:bookmark_opencmd = 'Tabdrop'
"Plug 'inkarkat/vim-ingo-library'
"Plug 'inkarkat/vim-mark' "{{{
"let g:mw_no_mappings = 1
"let g:mwDefaultHighlightingPalette = 'maximum'
"nnoremap <silent> 8 :let @/=""<cr>:call feedkeys("\<Plug>MarkSet")<cr>
"nmap * :let @/=""<cr>:silent MarkClear<cr>:call feedkeys("\<Plug>MarkSet")<cr>
"vnoremap <silent> 8 :<c-u>let @/=""<cr>:<C-u>if ! mark#DoMark(v:count, mark#GetVisualSelectionAsLiteralPattern())[0]<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
"vnoremap <silent> * :<c-u>let @/=""<cr>:silent MarkClear<cr>:<C-u>if ! mark#DoMark(v:count, mark#GetVisualSelectionAsLiteralPattern())[0]<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
"nnoremap <silent><leader>/ :let @/=""<cr>:silent MarkClear<cr>
"nmap n <Plug>MarkSearchCurrentNext
"nmap N <Plug>MarkSearchCurrentPrev

"function! StartMarkSearch()
"    autocmd CursorMoved * ++once silent call s:MarkSearchResult()
"endfunction
"function! s:MarkSearchResult()
"    let search_pat = getreg('/')
"    if empty(search_pat)
"        return
"    endif

"    let ind = index(mark#ToList(), search_pat)
"    if ind == -1
"        call mark#DoMarkAndSetCurrent(v:count, ingo#regexp#magic#Normalize(search_pat))
"    endif
"    let s:last_search=search_pat
"    let @/=""
"endfunction

"function! s:SelectAllMark()
"    call feedkeys("\<Plug>(VM-Start-Regex-Search)".join(mark#ToList(),"\\|")."\<cr>")
"    call feedkeys("\<Plug>(VM-Select-All)")
"endfunction

"function! s:VSelectAllMark()
"    call feedkeys("\<Plug>(VM-Start-Regex-Search)".join(mark#ToList(),"\\|")."\<cr>")
"    call feedkeys("\<Plug>(VM-Select-All)")
"endfunction

"nmap <leader>r :call <sid>SelectAllMark()<cr>
"vmap <leader>r :<c-u>call <sid>VSelectAllMark()<cr>
"nnoremap ? :call StartMarkSearch()<cr>/

"augroup VIM-MARK
"    autocmd!
"    autocmd VimEnter * let @/=""
"augroup END
""}}}
" Plug 'idanarye/vim-merginal' "{{{
" let g:merginal_splitType=''
" augroup MERGINAL
"     autocmd!
"     autocmd BufEnter Merginal:* wincmd J
" augroup END
"}}}

" Plug 'RRethy/vim-illuminate'
"Plug 'vimwiki/vimwiki' "{{{
"let g:vimwiki_folding='list'
"function! VimwikiLinkHandler(link)
"    try
"        execute 'silent !qday '.a:link
"        return 1
"    catch
"        echo "This can happen for a variety of reasons ..."
"    endtry
"    return 0
"endfunction
"function! SetupVimWiki()
"    vmap <buffer> <m-cr> <Plug>VimwikiNormalizeLinkVisualCR
"    vmap <buffer> <m-d> <Plug>VimwikiFollowLink
"    vmap <buffer> <m-s> <Plug>VimwikiGoBackLink
"endfunction
"augroup VIMWIKI
"    autocmd!
"    autocmd Filetype vimwiki command! -buffer BrowseCurrent
"                \ if filewritable(expand('%')) | silent noautocmd w | endif
"            \ <bar>
"            \ execute 'silent !'.$BROWSER.' '.vimwiki#html#Wiki2HTML(
"            \         expand(vimwiki#vars#get_wikilocal('path_html')),
"            \         expand('%'))
"    autocmd Filetype vimwiki call <sid>SetupVimWiki()
"augroup END
""}}}
"Plug 'camspiers/lens.vim'
"Plug 'git@github.com:ipod825/lens.vim', {'branch': 'disableoption'} "{{{
"function! s:LensDisable()
"    if &diff
"        return v:true
"    endif
"    return v:false
"endfunction
"" let g:Lens_custom_disable_check = function('s:LensDisable')
"let g:lens#disabled_filetypes = ['netranger', 'gitv', 'esearch']
"" let g:lens#disabled_buftypes = ['terminal']
"let g:lens#specify_dim_by_ratio = v:true
"let g:lens#width_resize_min=0.7
"let g:lens#width_resize_max=0.7
""}}}
"Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'} "{{{
"autocmd FileType denite call s:denite_my_settings()
"autocmd FileType denite-filter call s:denite_filter_my_settings()

"function! s:denite_filter_my_settings() abort
"    imap <silent><buffer> <c-c> <Plug>(denite_filter_quit)
"endfunction
"function! s:denite_my_settings() abort
"  nnoremap <silent><buffer><expr> <CR>
"  \ denite#do_map('do_action')
"  nnoremap <silent><buffer><expr> d
"  \ denite#do_map('do_action', 'delete')
"  nnoremap <silent><buffer><expr> p
"  \ denite#do_map('do_action', 'preview')
"  nnoremap <silent><buffer><expr> q
"  \ denite#do_map('quit')
"  nnoremap <silent><buffer><expr> i
"  \ denite#do_map('open_filter_buffer')
"  nnoremap <silent><buffer><expr> <Space>
"  \ denite#do_map('toggle_select').'j'
"endfunction
"augroup POST_PLUG_END
"    autocmd USER PLUG_END call denite#custom#option('default', {
"          \'winheight': 90*winheight(0)/100,
"          \'floating_preview': v:true,
"          \'filter_split_direction': 'floating',
"          \'highlight_mode_insert': 'CursorLine',
"          \'highlight_matched_range': 'None',
"          \ })
"augroup END
""}}}
"Plug 'cohama/lexima.vim' "{{{
"inoremap <m-e> <esc>ldlepi
""}}}
" Plug 'voldikss/vim-floaterm'
" " {{{ vim-floaterm
" nnoremap <m-f> :FloatermToggle<cr>
" tnoremap <m-f> <c-\><c-n>:FloatermToggle<cr>
" let g:floaterm_wintype='normal'
" let g:floaterm_position='bottom'
" let g:floaterm_width=0.95
" let g:floaterm_height=0.4
" Plug 'git@github.com:ipod825/gitv'
" " gitv {{{
" cnoreabbrev gv Gitv --all
" let g:Gitv_WipeAllOnClose = 1
" let g:Gitv_DoNotMapCtrlKey = 1
" let g:Gitv_OpenPreviewOnLaunch = 0
" " }}}

" Plug 'vim-scripts/LargeFile'
" let g:LargeFile=10

" Plug 'mg979/vim-xtabline'
" " vim-xtabline {{{
" let g:xtabline_settings = {}
" let g:xtabline_settings.current_tab_paths = 0
" let g:xtabline_settings.other_tabs_paths = 0
" let g:xtabline_settings.show_right_corner = 0
" let g:xtabline_settings.buffer_format = 2
" " }}}

" Plug 'sgur/vim-textobj-parameter'
" Plug 'liuchengxu/vista.vim'
" " vista{{{
" cnoreabbrev VI Vista!!
" let g:vista_cursor_delay=10
" let g:vista_echo_cursor_strategy="floating_win"
" let g:vista_stay_on_open=0
" let g:vista_close_on_jump=1
" }}}

" Plug 'junegunn/gv.vim', {'on_cmd': 'GV'} "{{{
" cnoreabbrev GB GV --branches
" augroup GVmapping
"     autocmd FileType GV nmap r q:GB<cr>
" augroup END
" " }}}
" Plug 'ipod825/vim-swap-parameters', {'do': 'bash '.g:vim_dir.'scripts/git-remote-reset.sh'}
" " vim-swap-parameters {{{
" nmap <M-,> <Plug>Swappmprev
" nmap <M-.> <Plug>Swappmnext
" " }}}
" Plug 'nelstrom/vim-visual-star-search'  " * in visual mode
" Plug 'Raimondi/delimitMate'
" " delimitMate {{{
" augroup DELIMITMATE
"     autocmd!
"     au FileType tex let b:delimitMate_quotes = "\" $"
" augroup End
" " }}}

" Plug 'Shougo/echodoc.vim'
" " echodoc {{{
" set noshowmode
" let g:echodoc_enable_at_startup = 1
" " }}}

" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
" Plug 'idanarye/vim-vebugger'
" let g:vebugger_leader='<Leader>d'
" Plug 'ipod825/vim-debugger'
" " vim-debugger {{{
" let g:debugger_mapping_python = {
"             \ 'n': '"next"',
"             \ 's': '"step"',
"             \ 'c': '"continue"',
"             \ 'B': "'break '.expand('%:p').':'.line('.')",
"             \ 'C': "'clear '.expand('%:p').':'.line('.')",
"             \ 'p': "'pp '. expand('<cword>')",
"             \ '<up>': '"up"',
"             \ '<down>': '"down"',
"             \ 'r': '"return"',
"             \ 'q': '"quit"',
"             \ 't': "'until ' .line('.')",
"             \}
" " }}}
"

" Plug 'terryma/vim-multiple-cursors' " helpful for refactoring code
" " vim-mutiple-cursors {{{
" let g:multi_cursor_use_default_mapping=0
" let g:multi_cursor_next_key='<C-n>'
" let g:multi_cursor_prev_key='<C-p>'
" let g:multi_cursor_skip_key='<C-x>'
" let g:multi_cursor_quit_key='<Esc>'
" function! Multiple_cursors_before()
"     let b:deoplete_disable_auto_complete = 1
" endfunction
" " }}}


" Plug 'sbdchd/neoformat', {'do': 'bash ' . g:vim_script_dir . 'neoformat.sh'}
" " neoformat {{{
" augroup fmt
"   autocmd!
"   au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
" augroup END
" let g:neoformat_enabled_python = ['yapf', 'docformatter', 'isort']
" let g:neoformat_run_all_formatters = 1
" let g:neoformat_basic_format_trim = 1
" " }}}

" " vim-lsp {{{
" Plug 'prabirshrestha/async.vim'
" if has('nvim')
"     " Plug 'prabirshrestha/vim-lsp', { 'do': ':UpdateRemotePlugins' }
" Plug '~/projects/vim/vim-lsp', { 'do': ':UpdateRemotePlugins' }
" else
"     Plug 'prabirshrestha/vim-lsp'
" endif
" function! s:LspGoTo(args)
"     TabdropPushTag
"     echom a:args['path']
"     let l:cmd = 'Tabdrop '.a:args['path']
"     execute l:cmd
" endfunction
" let g:lsp_custom_open_location = [function('s:LspGoTo')]
" let g:lsp_signs_enabled = 1         " enable signs
" let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
" let g:lsp_signs_error = {'text': '✗'}
" hi LSPVirtual ctermfg=244 ctermbg=233
" hi LSPText ctermbg=237
" highlight link LspErrorHighlight LSPText
" highlight link LspWarningHighlight LSPText
" highlight link LspErrorText LSPVirtual
" highlight link LspWarningText LSPVirtual
" nnoremap <silent><M-d> :LspDefinition<cr>
" nnoremap <silent><M-s> :TabdropPopTag<cr>
" nnoremap <silent><M-j> :LspHover<cr>
" nnoremap <silent><M-k> :call fzf#run(fzf#wrap({
"         \   'source':  ['LspHover', 'LspReferences', 'LspRename', 'LspStatus'],
"         \   'sink': {cmd->execute(cmd)}
"         \}))<cr>
" if !filereadable(g:vim_dir.'gwork.vim')
"   if executable('pyls')
"       au User lsp_setup call lsp#register_server({
"           \ 'name': 'pyls',
"           \ 'cmd': {server_info->['pyls']},
"           \ 'whitelist': ['python'],
"           \ })
"   endif
" endif
" " }}}
"
" " asynccomplete
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-buffer.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/asyncomplete-file.vim'
" Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
" if has("nvim")
"     Plug 'prabirshrestha/asyncomplete-necosyntax.vim',{ 'do': ':UpdateRemotePlugins' }
" else
"     Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
" endif
" Plug 'Shougo/neoinclude.vim'
" Plug 'kyouryuukunn/asyncomplete-neoinclude.vim'
" let g:asyncomplete_auto_completeopt=0
"
" augroup AsyncComplete
"   autocmd!
"   autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
"   autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
"         \ 'name': 'buffer',
"         \ 'whitelist': ['*'],
"         \ 'completor': function('asyncomplete#sources#buffer#completor'),
"         \ 'config': {
"         \    'max_buffer_size': 5000000,
"         \  },
"         \ }))
"   autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
"         \ 'name': 'file',
"         \ 'whitelist': ['*'],
"         \ 'priority': 10,
"         \ 'completor': function('asyncomplete#sources#file#completor')
"         \ }))
"   autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
"         \ 'name': 'ultisnips',
"         \ 'whitelist': ['*'],
"         \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
"         \ }))
"   autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
"         \ 'name': 'necosyntax',
"         \ 'whitelist': ['*'],
"         \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
"         \ }))
"   autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neoinclude#get_source_options({
"         \ 'name': 'neoinclude',
"         \ 'whitelist': ['cpp'],
"         \ 'refresh_pattern': '\(<\|"\|/\)$',
"         \ 'completor': function('asyncomplete#sources#neoinclude#completor'),
"         \ }))
" augroup end
