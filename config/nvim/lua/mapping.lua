local M = _G.mapping or {}
_G.mapping = M

local map = require'Vim'.map
local V = require 'Vim'

vim.g.mapleader = ' '
-- Mode Changing
map('n', ';', ':')
map('i', 'jk', '<esc>l')
map('c', 'jk', '<esc>')
map('o', 'jk', '<esc>')
map('c', '<m-d>', '<c-f>dwi')
map('v', '<cr>', '<esc>')
map('i', '<c-a>', '<esc><c-w>')

-- Moving Around
map('n', 'j', 'gj')
map('n', 'k', 'gk')
-- map('n', '<c-k>', '<cmd> lua mapping.previous_block()<cr>')
-- map('n', '<c-j>', '<cmd> lua mapping.next_block()<cr>')
-- map('v', '<c-k>', '<cmd> lua mapping.previous_block()<cr>')
-- map('v', '<c-j>', '<cmd> lua mapping.next_block()<cr>')
map('n', '<c-k>', '{')
map('n', '<c-j>', '}')
map('v', '<c-k>', '{')
map('v', '<c-j>', '}')
map('i', '<c-h>', '<left>')
map('i', '<c-l>', '<right>')
map('i', '<c-j>', '<down>')
map('i', '<c-k>', '<up>')
map('n', '<cr>', '<c-w>w')

-- Moving Around (home,END)
map('o', '<m-h>', 'g^')
map('o', '<m-l>', 'g$')
map('v', '<m-h>', 'g^')
map('v', '<m-l>', 'g$<left>')
map('n', '<m-h>', 'g^')
map('n', '<m-l>', 'g$')
map('i', '<m-h>', '<Esc>g^i')
map('i', '<m-l>', '<Esc>g_i')
map('c', '<m-h>', '<c-b>')
map('c', '<m-l>', '<c-e>')
map('t', '<m-h>', '<home>')
map('t', '<m-l>', '<end>')
function M.previous_block()
    if vim.bo.buftype ~= 'terminal' then
        local ori_line = V.current.line_number()
        vim.api.nvim_feedkeys('{', 'n', false)
        if V.current.line_number() == ori_line - 1 then
            vim.api.nvim_feedkeys('{{', 'n', true)
        end
        if V.current.line_number() ~= 1 then
            vim.api.nvim_feedkeys('j', 'n', true)
        end
    else
        vim.fn.search(vim.env.USER, 'Wbz')
    end
end
function M.next_block()
    if vim.bo.buftype ~= 'terminal' then
        local ori_line = V.current.line_number()
        vim.api.nvim_feedkeys('}', 'n', true)
        if V.current.line_number() == ori_line - 1 then
            vim.api.nvim_feedkeys('}', 'n', true)
        end
        if V.current.line_number() ~= 10000 then
            vim.api.nvim_feedkeys('k', 'n', true)
        end
    else
        vim.fn.search(vim.env.USER, 'Wbz')
    end
end

-- Terminal
map('n', '<m-t>', '<cmd>call v:lua.mapping.reuse_term("Tabdrop", getcwd())<cr>')
map('n', '<m-o>', '<cmd>call v:lua.mapping.reuse_term("split", getcwd())<cr>')
map('n', '<m-e>', '<cmd>call v:lua.mapping.reuse_term("vsplit", getcwd())<cr>')
map('n', '<m-s-t>', '<cmd>lua mapping.open_term("Tabdrop")<cr>')
map('n', '<m-s-o>', '<cmd>lua mapping.open_term("split")<cr>')
map('n', '<m-s-e>', '<cmd>lua mapping.open_term("vsplit")<cr>')
map('t', 'jk', [[<c-\><c-n>]])
map('t', '<esc>', [[<c-\><c-n>]])
map('t', '<m-j>', [[<c-\><c-n><cmd>lua mapping.toggle_term_nojk()<cr>i]])
map('t', '<c-a>', [[<c-\><c-n><c-w>]])
map('t', '<c-z>', '<c-v><c-z>')
map('t', '<c-k>', '<up>')
map('t', '<c-j>', '<down>')
map('c', '<c-k>', '<up>')
map('c', '<c-j>', '<down>')
vim.api.nvim_exec(
    'command! ToggleTermInsert let b:auto_term_insert=1-b:auto_term_insert | if b:auto_term_insert | startinsert | endif',
    false)
function M.open_term(open_cmd)
    vim.cmd(open_cmd)
    vim.cmd('term')
    vim.b.auto_term_insert = 1
    vim.cmd(
        'autocmd BufEnter <buffer> if b:auto_term_insert==1 | startinsert | endif')
    vim.cmd('startinsert')
end
M.id_to_term = M.id_to_term or {}
function M.reuse_term(open_cmd, id)
    id = id or 'default'
    if M.id_to_term[id] == nil then
        M.open_term(open_cmd)
        M.id_to_term[id] = vim.api.nvim_buf_get_name(0)
        vim.cmd(string.format(
                    'autocmd BufUnload <buffer> lua mapping.id_to_term["%s"] = nil',
                    id))
        map('t', '<c-d>', [[<c-\><c-n>:quit<cr>]], {buffer = true})
        return false
    else
        vim.cmd(string.format('%s %s', open_cmd, M.id_to_term[id]))
        return true
    end
end
function M.toggle_term_nojk()
    if vim.b.timeoutlen == nil then
        vim.b.timeoutlen = 10
        vim.cmd('set timeoutlen=10')
        vim.cmd(
            'autocmd BufEnter <buffer> if exists("b:timeoutlen") | execute("set timeoutlen=".b:timeoutlen) | endif')
        vim.cmd('autocmd BufLeave <buffer> set timeoutlen=500')
    else
        vim.b.timeoutlen = nil
        vim.cmd('set timeoutlen=500')
    end
end

-- Tab switching
map('n', '<c-h>', 'gT')
map('n', '<c-l>', 'gt')
map('n', '<c-m-h>', ':tabmove -1<cr>')
map('n', '<c-m-l>', ':tabmove +1<cr>')
map('t', '<c-h>', 'jkgT', {noremap = false})
map('t', '<c-l>', 'jkgt', {noremap = false})
map('n', '<c-m-j>', [[<c-\><c-n><cmd>lua mapping.move_to_previous_tab()<cr>]])
map('n', '<c-m-k>', [[<c-\><c-n><cmd>lua mapping.move_to_next_tab()<cr>]])
function M.move_to_previous_tab()
    if vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()) == 1 then
        vim.cmd('wincmd T')
        vim.cmd('silent! tabmove -1')
    else
        current_buf = vim.api.nvim_get_current_buf()
        vim.cmd('normal! gT')
        target_tab_page = vim.api.nvim_get_current_tabpage()
        vim.cmd('normal! gt')
        vim.cmd('close')
        vim.api.nvim_set_current_tabpage(target_tab_page)
        vim.cmd(string.format('vsplit | wincmd L | b%d', current_buf))
    end
end
function M.move_to_next_tab()
    if vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()) ==
        #vim.api.nvim_list_tabpages() then
        vim.cmd('wincmd T')
    else
        current_buf = vim.api.nvim_get_current_buf()
        vim.cmd('normal! gt')
        target_tab_page = vim.api.nvim_get_current_tabpage()
        vim.cmd('normal! gT')
        vim.cmd('close')
        vim.api.nvim_set_current_tabpage(target_tab_page)
        vim.cmd(string.format('vsplit | wincmd L | b%d', current_buf))
    end
end

-- Window
map('n', '<c-a>', '<c-w>')
map('i', '<c-a>', '<Esc><c-w>')
map('n', '<c-m-down>', '<c-w>+')
map('n', '<c-m-up>', '<c-w>-')
map('n', '<c-m-left>', '<c-w><')
map('n', '<c-m-right>', '<c-w>>')
map('n', 'q', '<cmd>quit<cr>')
map('n', 'Q', 'q')
map('n', '<m-w>', '<cmd>lua vim.wo.wrap = not vim.wo.wrap<cr>')

vim.env.SUDO_ASKPASS = "/usr/bin/ssh-askpass"
vim.cmd('cnoreabbrev help tab help')
vim.cmd('cnoreabbrev te Tabdrop')
vim.cmd('cnoreabbrev tc tabclose')
vim.cmd('cnoreabbrev sudow w !sudo -A tee % > /dev/null')
vim.cmd('cnoreabbrev man Man')
map('c', 'qq', ':bwipeout<cr>')

-- misc
-- paste yanked text in command line
map('c', '<m-p>', '<c-r>"')
-- paste current file name in command line
map('c', '<m-f>', '<c-r>%<c-f>')
-- yank to system clipboard
map('v', '<m-y>', '<cmd>lua mapping.yank_to_system_clipboard()<cr>')
function M.yank_to_system_clipboard()
    should_strip = vim.bo.buftype == 'terminal' and vim.fn.mode() == 'V'
    vim.cmd('silent! normal! "+y')
    if should_strip then
        src = vim.fn.getreg('+')
        w = vim.api.nvim_win_get_width(0)
        res, _ = string.gsub(src, "([^\n]+)\n", function(s)
            if #s == w then
                return s
            else
                return s .. '\n'
            end
        end)
        vim.fn.setreg('+', res)
    end
end
function M.paste_stay_last()
    local line = V.current.line_number
    vim.cmd('normal! p')
    local new_line = V.current.line_number
    if new_line ~= line then vim.cmd("normal! `]") end
end
map('v', 'y', 'y`]')
-- map('n', 'p', '<cmd>lua mapping.paste_stay_last()<cr>')
-- consistent paste for visual selection
map('v', 'p', '"_dP`]')
-- select last paste
map('n', '<m-p>', "V'[")
-- wrap long comment that is not automatically done by ale
map('n', 'U', '<cmd>lua mapping.comment_unwrap()<cr>')
function M.comment_unwrap()
    if vim.bo.filetype == "python" then
        vim.bo.textwidth = 79
    else
        vim.bo.textwidth = 80
    end
    vim.cmd('normal! vgq')
    vim.bo.textwidth = 0
end
-- folding
map('n', '<leader><space>', 'za', {noremap = false})
map('n', '<leader>z', 'zMzvzz')
-- simple calculator
map('i', '<c-c>', '<c-o>yiW<end>=<c-r>=<c-r>0<cr>')
-- shift
map('n', '>', '>>')
map('n', '<', '<<')
map('v', '>', '>gv')
map('v', '<', '<gv')

-- Diff
map('n', '<leader>h', '<cmd>lua mapping.diff_get()<cr>')
map('n', '<leader>l', '<cmd>lua mapping.diff_put()<cr>')
map('v', '<leader>h', ':call v:lua.mapping.diff_get()<cr>')
map('v', '<leader>l', ':call v:lua.mapping.diff_put()<cr>')
function M.diff_get()
    if #vim.api.nvim_tabpage_list_wins(0) == 3 then
        vim.cmd('diffget 3:')
    else
        if vim.fn.winnr() == 1 then
            vim.cmd('diffget')
        else
            vim.cmd('diffput')
        end
    end
end
function M.diff_put()
    if #vim.api.nvim_tabpage_list_wins(0) == 3 then
        vim.cmd('diffget 2:')
    else
        if vim.fn.winnr() == 2 then
            vim.cmd('diffget')
        else
            vim.cmd('diffput')
        end
    end
end

return M
