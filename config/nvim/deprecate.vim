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

" Plug 'junegunn/gv.vim', {'on_cmd': 'GV'}
" " GV{{{
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
