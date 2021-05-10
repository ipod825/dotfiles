local M = _G.fzf_cfg or {}
_G.fzf_cfg = M
local map = require'Vim'.map
local add_util_menu = require'utils'.add_util_menu

vim.g.fzf_layout = {up = '100%'}
vim.g.fzf_action = {
    ['ctrl-e'] = 'edit',
    ['Enter'] = 'Tabdrop',
    ['ctrl-s'] = 'split',
    ['ctrl-v'] = 'vsplit'
}
vim.g.fzf_ft = ''
vim.api.nvim_exec([[
augroup FZF
    autocmd!
    autocmd! FileType fzf if strlen(g:fzf_ft)  && g:fzf_ft!= "man" | silent! let &ft=g:fzf_ft | endif
    autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
    autocmd VimEnter * command! -bang -nargs=? Buffers call fzf#vim#buffers(<q-args>, {'options': '--no-preview'}, <bang>0)
augroup END
]], false)

function M.fzf(source, sink, options)
    if sink ~= nil then
        local fzf_opts_wrap = vim.fn['fzf#wrap'](
                                  {source = source, options = options})
        -- 'sink*' needs to be defined outside wrap()
        fzf_opts_wrap['sink*'] = function(l) sink(l[2]) end
        vim.fn['fzf#run'](fzf_opts_wrap)
    else
        -- fzf's default handler is written in vim script (an s: function),
        -- currently it's translated into nil. This is a WAR by calling fzf#wrap
        -- in vimscript in vim.
        local source_str = string.format('["%s"]', table.concat(source, '","'))
        if options ~= nil then
            local options_str = table.concat(options, ',')
            vim.cmd(string.format(
                        [[call fzf#run(fzf#wrap({'source':%s, 'options':%s}))]],
                        source_str, options_str))
        else
            vim.cmd(string.format([[call fzf#run(fzf#wrap({'source':%s}))]],
                                  source_str))
        end
    end
end

map('n', '/', '<cmd>lua fzf_cfg.search_word()<cr>')
function M.search_word()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for k, v in pairs(lines) do lines[k] = string.format(' %4d %s', k, v) end
    M.fzf(lines, function(l)
        local lineno
        _, _, lineno = string.find(l, "(%d+)%s*")
        vim.cmd(lineno)
    end, {
        '--ansi', '--multi', '--no-sort', '--exact', '--nth', '2..', '--color',
        'hl:reverse:underline:-1:reverse:underline:-1'
    })
end

map('n', '<c-o>', '<cmd>lua fzf_cfg.open_file_from_project_root()<cr>')
function M.open_file_from_project_root()
    vim.cmd(string.format('Files %s', vim.fn.FindRootDirectory()))
end

map('n', '<leader>e', '<cmd>lua fzf_cfg.open_config_files()<cr>')
function M.open_config_files()
    M.fzf(vim.fn.systemlist('$HOME/dotfiles/misc/watchfiles.sh nvim'))
end

map('n', '<c-m-o>', '<cmd>lua fzf_cfg.open_recent_files()<cr>')
vim.cmd('cnoreabbrev f lua fzf_cfg.open_recent_files()')
function M.open_recent_files()
    M.fzf(vim.tbl_filter(function(val) return 0 ~= vim.fn.filereadable(val) end,
                         vim.v.oldfiles))
end

function M.select_from_util_menu(ids)
    ids = ids or {'default'}
    if type(ids) == 'string' then ids = {ids} end
    local util_fns = {}
    for _, id in pairs(ids) do
        util_fns = vim.tbl_extend('force', util_fns,
                                  require'utils'.util_fns[id] or {})
    end
    local names = vim.tbl_keys(util_fns)
    table.sort(names)
    M.fzf(names, function(e) util_fns[e]() end)
end
map('n', '<leader><cr>', '<cmd>lua fzf_cfg.select_from_util_menu()<cr>')

function M.copy_abs_path()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.fn.setreg('"', path)
end
add_util_menu('CopyAbsPath', M.copy_abs_path)

function M.copy_base_name()
    local path = vim.fn.expand('%:p:t')
    vim.fn.setreg('+', path)
    vim.fn.setreg('"', path)
end
add_util_menu('CopyBaseName', M.copy_base_name)

function M.select_yank()
    local yank_history = vim.tbl_map(function(e) return e.text end,
                                     vim.fn['yoink#getYankHistory']())
    yank_history = vim.tbl_filter(function(e) return #e > 1 end, yank_history)
    M.fzf(yank_history, function(l)
        vim.fn.setreg('"', l)
        vim.cmd('normal! p')
    end)
end
add_util_menu('SelectYank', M.select_yank)

function M.abolish()
    M.fzf({'camelCase:c', 'MixedCase:m', 'snake_case:s', 'SNAKE_UPPERCASE:u'},
          function(l)
        local cmd
        _, _, cmd = string.find(l, ':(.+)')
        vim.defer_fn(function()
            vim.cmd(string.format('normal cr%s', cmd))
        end, 0)
    end)
end
add_util_menu('DoAbolish', M.abolish)

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
add_util_menu('BinEdit', M.bin_edit)

function M.related_file()
    local name = vim.fn.expand('%:t:r')
    vim.cmd(string.format('Files %s', vim.fn.FindRootDirectory()))
    vim.api.nvim_input(name)
end
add_util_menu('RelatedFile', M.related_file)

function M.switch_source_header(bufnr)
    local params = {uri = vim.uri_from_bufnr(0)}
    vim.lsp.buf_request(0, 'textDocument/switchSourceHeader', params,
                        function(err, _, result)
        if err then error(tostring(err)) end
        if not result then
            print("Corresponding file can’t be determined")
            return
        end
        vim.api.nvim_command('Tabdrop ' .. vim.uri_to_fname(result))
    end)
end
add_util_menu('OpenSourceHeader', M.switch_source_header)

M.lsp_context = M.lsp_context or {}
function M.select_from_lsp_util_menu()
    M.lsp_context.line_number = require'Vim'.current.line_number()
    M.lsp_context.col_number = require'Vim'.current.col_number()
    M.select_from_util_menu("lsp")
end

map('n', 'LC', '<cmd>lua fzf_cfg.select_from_lsp_util_menu()<cr>')
map('n', 'LH', '<cmd>lua vim.lsp.buf.hover()<cr>')
add_util_menu('References', vim.lsp.buf.references, 'lsp')
add_util_menu('IncomingCalls', vim.lsp.buf.incoming_calls, 'lsp')
add_util_menu('OutgoingCalls', vim.lsp.buf.outgoing_calls, 'lsp')
add_util_menu('Rename', vim.lsp.buf.rename, 'lsp')

function M.lsp_diagnostic_open()
    vim.lsp.diagnostic.set_loclist()
    vim.defer_fn(function()
        vim.fn.search(string.format('|%d col', M.lsp_context.line_number), 'cw')
    end, 10)
end
-- add_util_menu('DiagnosticOpen', M.lsp_diagnostic_open, 'lsp')
add_util_menu('DiagnosticDocument',
              function() require'trouble'.open('document') end, 'lsp')
add_util_menu('DiagnosticWorkspace',
              function() require'trouble'.open('workspace') end, 'lsp')

function M.cheat_sheet()
    local id = vim.b.terminal_job_id
    local cheats = vim.list_extend(vim.fn.systemlist(
                                       string.format(
                                           'cat %s/dotfiles/misc/cheatsheet',
                                           vim.env.HOME)), vim.fn.systemlist(
                                       string.format(
                                           'cat %s/.local/share/cheatsheet',
                                           vim.env.HOME)))
    M.fzf(cheats, function(l)
        vim.fn.chansend(id, l)
        vim.defer_fn(function() vim.cmd('normal! i') end, 50)
    end, {'--exact'})
end
map('t', '<m-c>', '<cmd>lua fzf_cfg.cheat_sheet()<cr>')

return M
