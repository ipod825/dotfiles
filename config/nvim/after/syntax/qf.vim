" conceal ansi color for work environment
if exists('g:GWORK')
    syntax match ansiSuppress  conceal '\e\[[0-9;]*m'
    hi link ansiSuppress Conceal

    let c = 0
    while c < 256
      exec 'syntax match QF'.c.' "\e\[1m\e\['.c.'m[^\e]*\e\[0m"  contains=ansiSuppress'
      exec 'hi QF'.c.' ctermfg='.c
      let c += 1
    endwhile
endif
