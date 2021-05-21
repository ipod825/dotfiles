local M = _G.Vim or {}
_G.Vim = M

function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    if options.buffer ~= nil then
        options.buffer = nil
        vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
end

M.current = {}
function M.current.line_number() return vim.api.nvim_win_get_cursor(0)[1] end

function M.current.col_number() return vim.api.nvim_win_get_cursor(0)[2] end

function M.current.filename() return vim.fn.expand('%:p') end

function M.current.line() return vim.api.nvim_get_current_line() end

function M.current.word() return vim.fn.expand('<cword>') end

function M.current.char()
    return vim.fn.strcharpart(vim.fn.strpart(M.current.line(),
                                             M.current.col_number()), 0, 1)
end

function M.current.textobject(mark)
    vim.cmd('noautocmd normal! "ayi' .. mark)
    return vim.fn.getreg('a')
end

function M.save_keymap(keys, mode, is_global)
    mode = mode or 'n'
    if is_global == nil then is_global = true end

    if type(keys) ~= "table" then keys = {keys} end

    local not_mapped_keys = {}
    -- normalize keys
    keys = vim.tbl_map(function(e)
        local mapping = vim.fn.maparg(e, mode, false, true)
        local res = mapping.lhs
        if res == nil or (not is_global and mapping.buffer == 0) then
            table.insert(not_mapped_keys, {lhs = e, mode = mode})
        else
            res = string.gsub(res, '<Space>', ' ')
        end
        return res
    end, keys)

    local res = nil
    if is_global then
        res = vim.list_extend(not_mapped_keys,
                              vim.tbl_filter(
                                  function(e)
                return vim.tbl_contains(keys, e.lhs)
            end, vim.api.nvim_get_keymap(mode)))
    else
        res = vim.list_extend(not_mapped_keys,
                              vim.tbl_filter(
                                  function(e)
                return vim.tbl_contains(keys, e.lhs)
            end, vim.api.nvim_buf_get_keymap(0, mode)))
    end
    local buffer_nr = is_global and -1 or vim.api.nvim_get_current_buf()
    res = vim.tbl_map(function(e)
        e.buffer = buffer_nr
        return e
    end, res)
    return res
end

function M.restore_keymap(mappings)
    for _, v in pairs(mappings) do
        local options = {
            noremap = (v.noremap and v.noremap ~= 0),
            nowait = (v.nowait and v.nowait ~= 0),
            silent = (v.silent and v.silent ~= 0),
            script = (v.script and v.script ~= 0),
            expr = (v.expr and v.expr ~= 0),
            unique = (v.unique and v.unique ~= 0)
        }
        if v.buffer > 0 then
            if v.rhs then
                vim.api.nvim_buf_set_keymap(v.buffer, v.mode, v.lhs, v.rhs,
                                            options)
            else
                vim.api.nvim_buf_del_keymap(v.buffer, v.mode, v.lhs)
            end
        else
            if v.rhs then
                vim.api.nvim_set_keymap(v.mode, v.lhs, v.rhs, options)
            else
                vim.api.nvim_del_keymap(v.mode, v.lhs)
            end
        end
    end
end

function M.term_feed(str) vim.fn.feedkeys(string.gsub(str, '%s+', ' ') .. '\r') end

function M.feedkeys(key, mode)
    key = vim.api.nvim_replace_termcodes(key, true, false, true)
    vim.api.nvim_feedkeys(key, mode, true)
end

return M
