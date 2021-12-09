cnoreabbrev G Gina status -s
cnoreabbrev gbr Gina branch
cnoreabbrev glg Gina log --branches --graph
cnoreabbrev glc exec 'Gina log --branches --graph --follow --author="Shih-Ming Wang" -- '.expand("%:p")
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
    autocmd Filetype git silent! tabmove -1
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
	call gina#custom#command#option('/\%(diff\|commit\|status\|branch\|log\)', '--opener', 'tab drop')
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
	call gina#custom#mapping#nmap('status', 'cr','<cmd>call GinaCommit("--reuse-message=HEAD@{1}")<cr>')
    call gina#custom#mapping#nmap('log', '<cr>','<Plug>(gina-show-vsplit)')
    call gina#custom#mapping#nmap('log', 'dd','<Plug>(gina-show-tab)')
    call gina#custom#mapping#nmap('log', 'DD','<Plug>(gina-changes-between)')
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
    call gina#custom#mapping#nmap('branch', 'dd','<Plug>(gina-show-commit-tab)')
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
