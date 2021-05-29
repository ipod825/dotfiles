local M = _G.fuzzy_menu or {}
_G.fuzzy_menu = M
local map = require'Vim'.map
local fuzzy_run = require'fzf_cfg'.fzf

M.actions = M.actions or {default = {}}
function M.add_util_menu(name, fn, id)
    id = id or 'default'
    if M.actions[id] == nil then M.actions[id] = {} end
    if M.actions[id][name] == nil then M.actions[id][name] = fn end
end

map('n', '<leader><cr>', '<cmd>lua fuzzy_menu.select()<cr>')
function M.select(ids)
    ids = ids or {'default'}
    if type(ids) == 'string' then ids = {ids} end
    local actions = {}
    for _, id in pairs(ids) do
        actions = vim.tbl_extend('force', actions, M.actions[id] or {})
    end
    local names = vim.tbl_keys(actions)
    table.sort(names)
    fuzzy_run(names, function(e)
        if type(actions[e]) == 'table' then
            actions[e].fn(actions[e].context_fn())
        else
            actions[e]()
        end
    end)
end

map('n', '/', '<cmd>lua fuzzy_menu.search_word()<cr>')
function M.search_word()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for k, v in pairs(lines) do lines[k] = string.format(' %4d %s', k, v) end
    fuzzy_run(lines, function(l)
        local lineno
        _, _, lineno = string.find(l, "(%d+)%s*")
        vim.cmd(lineno)
    end, {
        '--ansi', '--multi', '--no-sort', '--exact', '--nth', '2..', '--color',
        'hl:reverse:underline:-1:reverse:underline:-1'
    })
end

map('n', '<c-o>', '<cmd>lua fuzzy_menu.open_file_from_project_root()<cr>')
function M.open_file_from_project_root()
    vim.cmd(string.format('Files %s', vim.fn.FindRootDirectory()))
end

map('n', '<leader>e', '<cmd>lua fuzzy_menu.open_config_files()<cr>')
function M.open_config_files()
    fuzzy_run(vim.fn.systemlist('$HOME/dotfiles/misc/watchfiles.sh nvim'))
end

map('n', '<c-m-o>', '<cmd>lua fuzzy_menu.open_recent_files()<cr>')
vim.cmd('cnoreabbrev f lua fuzzy_menu.open_recent_files()')
function M.open_recent_files()
    fuzzy_run(vim.tbl_filter(function(val)
        return 0 ~= vim.fn.filereadable(val)
    end, vim.v.oldfiles))
end

function M.copy_abs_path()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.fn.setreg('"', path)
end
M.add_util_menu('CopyAbsPath', M.copy_abs_path)

function M.copy_base_name()
    local path = vim.fn.expand('%:p:t')
    vim.fn.setreg('+', path)
    vim.fn.setreg('"', path)
end
M.add_util_menu('CopyBaseName', M.copy_base_name)

function M.select_yank()
    local yank_history = vim.tbl_map(function(e) return e.text end,
                                     vim.fn['yoink#getYankHistory']())
    yank_history = vim.tbl_filter(function(e) return #e > 1 end, yank_history)
    fuzzy_run(yank_history, function(l)
        vim.fn.setreg('"', l)
        vim.cmd('normal! p')
    end)
end
M.add_util_menu('SelectYank', M.select_yank)

function M.abolish()
    fuzzy_run({
        'camelCase:c', 'MixedCase:m', 'snake_case:s', 'SNAKE_UPPERCASE:u'
    }, function(l)
        local cmd
        _, _, cmd = string.find(l, ':(.+)')
        vim.defer_fn(function()
            vim.cmd(string.format('normal cr%s', cmd))
        end, 0)
    end)
end
M.add_util_menu('DoAbolish', M.abolish)

function M.bin_edit()
    vim.bo.bin = true
    vim.api.nvim_exec([[
      autocmd BufReadPost <buffer> if &bin | %!xxd
      autocmd BufReadPost <buffer> set ft=xxd | endif
      autocmd BufWritePre <buffer> if &bin | let b:cursorpos=getcurpos() | %!xxd -r
      autocmd BufWritePre <buffer> endif
      autocmd BufWritePost <buffer> if &bin | undojoin | silent keepjumps %!xxd
      autocmd BufWritePost <buffer> set nomod | call setpos('.', b:cursorpos) | endif
      edit
  ]], false)
end
M.add_util_menu('BinEdit', M.bin_edit)

function M.related_file()
    local name = vim.fn.expand('%:t:r')
    vim.cmd(string.format('Files %s', vim.fn.FindRootDirectory()))
    vim.api.nvim_input(name)
end
M.add_util_menu('RelatedFile', M.related_file)

function M.cheat_sheet()
    local id = vim.b.terminal_job_id
    local cheats = vim.list_extend(vim.fn.systemlist(
                                       string.format(
                                           'cat %s/dotfiles/misc/cheatsheet',
                                           vim.env.HOME)), vim.fn.systemlist(
                                       string.format(
                                           'cat %s/.local/share/cheatsheet',
                                           vim.env.HOME)))
    fuzzy_run(cheats, function(l)
        if id then
            vim.fn.chansend(id, l)
            vim.defer_fn(function() vim.cmd('normal! i') end, 50)
        else
            vim.fn.setreg('"', l)
        end
    end, {'--exact'})
end
map('t', '<m-c>', '<cmd>lua fuzzy_menu.cheat_sheet()<cr>')
map('n', '<m-c>', '<cmd>lua fuzzy_menu.cheat_sheet()<cr>')

return M
