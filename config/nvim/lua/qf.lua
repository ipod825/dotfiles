local M = _G.qf or {}
_G.qf = M
local Vim = require 'Vim'
local map = require'Vim'.map

M.namespace = vim.api.nvim_create_namespace("QfHi")
M.last_target_buf_id = -1

vim.api.nvim_exec([[
augroup QF
    autocmd!
    autocmd FileType qf lua qf.setup()
augroup END
]], false)

function M.preview()
    local _, _, fname, line, col = Vim.current.line():find(
                                       "(.*)|(%d*) col (%d*)")
    if line == nil or col == nil then return end
    line = tonumber(line)
    col = tonumber(col)

    local qf_win_id = vim.api.nvim_get_current_win()
    local preview_win_nr = -1
    for _, v in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if v ~= qf_win_id then preview_win_nr = v end
    end
    if preview_win_nr == -1 then return end

    M.target_buf_id = vim.fn.bufnr(fname)
    if M.target_buf_id > 0 then
        vim.api.nvim_win_set_buf(preview_win_nr, M.target_buf_id)
        vim.api.nvim_win_set_cursor(preview_win_nr, {line, col})
    else
        vim.api.nvim_set_current_win(preview_win_nr)
        vim.cmd('edit ' .. fname)
        vim.api.nvim_win_set_cursor(preview_win_nr, {line, col})
        vim.api.nvim_set_current_win(qf_win_id)
    end

    vim.api.nvim_buf_clear_namespace(M.target_buf_id, M.namespace, 0, -1)
    vim.api.nvim_buf_add_highlight(M.target_buf_id, M.namespace,
                                   'LspDiagnosticsUnderlineError', line - 1,
                                   col - 1, -1)
end

function M.on_leave()
    vim.api.nvim_buf_clear_namespace(M.target_buf_id, M.namespace, 0, -1)
end

function M.setup()
    vim.cmd('autocmd CursorMoved <buffer> lua qf.preview()')
    vim.cmd('autocmd BufLeave <buffer> lua qf.on_leave()')
    vim.api.nvim_win_set_height(0, 5)
    map('n', 'j', '<down>', {buffer = true})
    map('n', 'k', '<up>', {buffer = true})
end
