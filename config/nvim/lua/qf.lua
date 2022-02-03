local M = _G.qf or {}
_G.qf = M
local map = require'Vim'.map

vim.api.nvim_exec([[
augroup QF
    autocmd!
    autocmd FileType qf lua qf.setup()
augroup END
]], false)

function M.open() require('bqf.qfwin.handler').open(false) end

function M.setup()
    vim.cmd('silent! wincmd J')
    -- vim.cmd(
    --     'autocmd BufEnter <buffer> nnoremap <buffer> <cr> <cmd>lua qf.open()<cr>')
    map('n', 'j', '<down>', {buffer = true})
    map('n', 'k', '<up>', {buffer = true})
    map('n', '<cr>', '<cmd>lua qf.open()<cr>', {buffer = true})
end

return M
