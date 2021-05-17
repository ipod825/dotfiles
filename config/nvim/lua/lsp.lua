local M = _G.lsp or {}
_G.lsp = M

local map = require'Vim'.map
local add_util_menu = require'fuzzy_menu'.add_util_menu
local Vim = require 'Vim'

function M.goto_tag_or_lsp_def()
    if #(vim.fn.taglist(vim.fn.expand('<cword>'))) > 0 then
        vim.cmd('TabdropPushTag')
        vim.api.nvim_exec('silent! TagTabdrop', true)
    else
        vim.lsp.buf.definition()
    end
end
map('n', '<m-d>', '<cmd>lua lsp.goto_tag_or_lsp_def()<cr>')
map('n', '<m-s>', '<cmd>TabdropPopTag<cr>')
map('n', 'LH', '<cmd>lua vim.lsp.buf.hover()<cr>')
map('n', 'LA', '<cmd>lua vim.lsp.buf.code_action()<cr>')

function M.goto_handler(_, method, res)
    if res == nil or vim.tbl_isempty(res) then
        print('No location found')
        return nil
    end
    vim.cmd('TabdropPushTag')
    local uri = res[1].uri or res[1].targetUri
    local range = res[1].range or res[1].targetRange
    vim.fn['tabdrop#tabdrop'](vim.uri_to_fname(uri), range.start.line + 1,
                              range.start.character + 1)
    if #res > 1 then
        vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(res))
        vim.api.nvim_command("copen")
    end
end
vim.lsp.handlers['textDocument/declaration'] = M.goto_handler
vim.lsp.handlers['textDocument/definition'] = M.goto_handler
vim.lsp.handlers['textDocument/typeDefinition'] = M.goto_handler
vim.lsp.handlers['textDocument/implementation'] = M.goto_handler

M.is_editing_signature = false
function M.signature_help_handler(a, b, result)
    local params = result.parameters or result.signatures[1].parameters
    if params ~= nil then
        local line_nr = Vim.current.line_number() - 1
        local col_nr = Vim.current.col_number()

        params = table.concat(vim.tbl_map(
                                  function(e)
                return string.format('`%s`', e.label)
            end, params), ', ')
        vim.api.nvim_buf_set_text(0, line_nr, col_nr, line_nr, col_nr, {params})
        vim.cmd('normal va`')

        Vim.feedkeys('<c-g>', 'v', false)
    end
end
vim.lsp.handlers['textDocument/signatureHelp'] = M.signature_help_handler

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
    require'fuzzy_menu'.select("lsp")
end

map('n', 'LC', '<cmd>lua lsp.select_from_lsp_util_menu()<cr>')
map('n', 'LH', '<cmd>lua vim.lsp.buf.hover()<cr>')
add_util_menu('References', vim.lsp.buf.references, 'lsp')
add_util_menu('IncomingCalls', vim.lsp.buf.incoming_calls, 'lsp')
add_util_menu('OutgoingCalls', vim.lsp.buf.outgoing_calls, 'lsp')
add_util_menu('Rename', vim.lsp.buf.rename, 'lsp')
add_util_menu('CodeAction', vim.lsp.buf.code_action, 'lsp')

function M.lsp_diagnostic_open()
    vim.lsp.diagnostic.set_loclist()
    vim.defer_fn(function()
        vim.fn.search(string.format('|%d col', M.lsp_context.line_number), 'cw')
    end, 10)
end
add_util_menu('DiagnosticOpen', M.lsp_diagnostic_open, 'lsp')
