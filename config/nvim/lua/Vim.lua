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

function M.current.line() return vim.fn.getline('.') end

function M.current.word() return vim.fn.expand('<cword>') end

function M.save_keymap(keys, mode, is_global)
    mode = mode or 'n'
    if is_global == nil then is_global = true end

    -- normalize keys 
    keys = vim.tbl_map(function(e)
        local res = vim.fn.maparg(e, mode, false, true).lhs
        return string.gsub(res, '<Space>', ' ')
    end, keys)

    if is_global then
        return vim.tbl_filter(function(e)
            return vim.tbl_contains(keys, e.lhs)
        end, vim.api.nvim_get_keymap(mode))
    else
        return vim.tbl_filter(function(e)
            return vim.tbl_contains(keys, e.lhs)
        end, vim.api.nvim_buf_get_keymap(mode))
    end
end

function M.restore_keymap(mappings)
    for _, v in pairs(mappings) do
        opts = {
            noremap = (v.noremap or v.noremap == 1),
            nowait = (v.nowait or v.nowait == 1),
            nowait = v.nowait == 1
        }

        vim.api.nvim_set_keymap(v.mode, v.lhs, v.rhs, {
            noremap = (v.noremap and v.noremap ~= 0),
            nowait = (v.nowait and v.nowait ~= 0),
            silent = (v.silent and v.silent ~= 0),
            script = (v.script and v.script ~= 0),
            expr = (v.expr and v.expr ~= 0),
            unique = (v.unique and v.unique ~= 0)
        })
    end
end

function M.term_feed(str) vim.fn.feedkeys(string.gsub(str, '%s+', ' ') .. '\r') end

return M
