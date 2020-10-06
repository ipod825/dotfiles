function! Save_mappings(keys, mode, is_global) abort
    let mappings = {}
    if a:is_global
        for l:key in a:keys
            let buf_local_map = maparg(l:key, a:mode, 0, 1)
            sil! exe a:mode.'unmap <buffer> '.l:key
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                                \     ? map_info
                                \     : {
                                        \ 'unmapped' : 1,
                                        \ 'buffer'   : 0,
                                        \ 'lhs'      : l:key,
                                        \ 'mode'     : a:mode,
                                        \ }
            call Restore_mappings({l:key : buf_local_map})
        endfor
    else
        for l:key in a:keys
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                                \     ? map_info
                                \     : {
                                        \ 'unmapped' : 1,
                                        \ 'buffer'   : 1,
                                        \ 'lhs'      : l:key,
                                        \ 'mode'     : a:mode,
                                        \ }
        endfor
    endif
    return mappings
endfunction

function! Restore_mappings(mappings) abort
    for [lhs, mapping] in items(a:mappings)
        if empty(mapping)
            continue
        endif
        if has_key(mapping, 'unmapped')
            sil! exe mapping.mode.'unmap '
                                \ .(mapping.buffer ? ' <buffer> ' : '')
                                \ . mapping.lhs
        else
            let rhs = mapping.rhs
            if has_key(mapping, 'sid')
                let rhs = substitute(rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')
            endif
            exe     mapping.mode
               \ . (mapping.noremap ? 'noremap   ' : 'map ')
               \ . (mapping.buffer  ? ' <buffer> ' : '')
               \ . (mapping.expr    ? ' <expr>   ' : '')
               \ . (mapping.nowait  ? ' <nowait> ' : '')
               \ . (mapping.silent  ? ' <silent> ' : '')
               \ . lhs.' '.rhs
        endif
    endfor
endfunction

let s:dirctory_register = {}
function! FindDirectory(anchor, ...)
    if a:0 == 2
        let l:name = a:1
        let l:res = get(s:dirctory_register, l:name, '')
    else
        let l:res = ""
    endif

    if !l:res
        let l:dir = getcwd()
        while len(l:dir)>1
            if filereadable('/'.l:dir.'/'.a:anchor) || isdirectory('/'.l:dir.'/'.a:anchor)
                let l:res = l:dir
                break
            endif
            let l:dir = fnamemodify(l:dir, ':h')
        endwhile
        if a:0 == 2
            let s:dirctory_register[l:name] = l:res
        endif
    endif
    return l:res
endfunction
