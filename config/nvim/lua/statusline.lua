local M = _G.spaceline or {}
_G.spaceline = M
local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'LuaTree', 'vista', 'dbui'}

M.colors = {
    bg = '#282c34',
    yellow = '#fabd2f',
    cyan = '#56b6c2',
    darkblue = '#203663',
    green = '#98c379',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#d16d9e',
    grey = '#c0c0c0',
    blue = '#61afef',
    red = '#ec5f67'
}

M.mode_color = {
    n = M.colors.green,
    i = M.colors.blue,
    v = M.colors.blue,
    [''] = M.colors.cyan,
    V = M.colors.cyan,
    c = M.colors.yellow,
    no = M.colors.red,
    s = M.colors.orange,
    S = M.colors.orange,
    [''] = M.colors.orange,
    ic = M.colors.yellow,
    R = M.colors.blue,
    ['r?'] = M.colors.cyan,
    ['!'] = M.colors.red,
    t = M.colors.red
}

M.mode_lut = {
    n = 'NORMAL',
    i = 'INSERT',
    c = 'COMMAND',
    V = 'VISUAL',
    v = 'VISUAL',
    s = 'SELECT',
    r = 'REPLACE',
    R = 'REPLACE',
    [''] = 'VISUAL',
    t = 'TERM'
}

function M.buffer_not_empty()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
    return false
end

function M.checkwidth()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then return true end
    return false
end

gls.left = {
    {
        ViMode = {
            provider = function()
                vim.api.nvim_command(string.format(
                                         'hi GalaxyViMode guifg=%s guibg=%s',
                                         M.colors.bg,
                                         M.mode_color[vim.fn.mode()]))
                return '  ' .. M.mode_lut[vim.fn.mode()] .. ' '
            end
        }
    }, {
        ViModeSeparator = {
            provider = function()
                local bg = M.colors.darkblue
                if not M.buffer_not_empty() then bg = M.colors.bg end
                vim.api.nvim_command(string.format(
                                         'hi GalaxyViModeSeparator guifg=%s guibg=%s',
                                         M.mode_color[vim.fn.mode()], bg))
                return ''
            end
        }
    }, {
        FileNamePad = {
            provider = function() return ' ' end,
            condition = M.buffer_not_empty,
            highlight = {M.colors.darkblue, M.colors.darkblue}
        }
    }, {
        FileName = {
            provider = {'FileName', 'FileSize'},
            condition = M.buffer_not_empty,
            highlight = {M.colors.magenta, M.colors.darkblue},
            separator = '',
            separator_highlight = {M.colors.darkblue, M.colors.purple}
        }
    }, {
        GitIcon = {
            provider = function() return '  ' end,
            condition = M.buffer_not_empty,
            highlight = {M.colors.orange, M.colors.purple}
        }
    }, {
        GitBranch = {
            provider = 'GitBranch',
            condition = function()
                SkipStatusHeavyFns = SkipStatusHeavyFns or {}
                for _, skip in pairs(SkipStatusHeavyFns) do
                    if skip() then return false end
                end
                return M.buffer_not_empty()
            end,
            highlight = {M.colors.grey, M.colors.purple},
            separator = '',
            separator_highlight = {M.colors.purple, M.colors.bg}
        }
    }, {
        DiagnosticError = {
            provider = 'DiagnosticError',
            icon = '  ',
            highlight = {M.colors.red, M.colors.bg}
        }
    }, {Space = {provider = function() return ' ' end}}, {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            icon = '  ',
            highlight = {M.colors.blue, M.colors.bg}
        }
    }
}

gls.right = {
    {
        FileFormat = {
            provider = 'FileFormat',
            separator = '',
            separator_highlight = {M.colors.purple, M.colors.bg},
            highlight = {M.colors.grey, M.colors.purple}
        }
    }, {
        LineInfo = {
            provider = 'LineColumn',
            separator = '|',
            separator_highlight = {M.colors.darkblue, M.colors.purple},
            highlight = {M.colors.grey, M.colors.purple}
        }
    }, {
        PerCent = {
            provider = 'LinePercent',
            separator = '',
            separator_highlight = {M.colors.darkblue, M.colors.purple},
            highlight = {M.colors.grey, M.colors.darkblue}
        }
    }
}

gls.short_line_right = {
    {
        ShortLineInfo = {
            provider = 'LineColumn',
            separator_highlight = {M.colors.grey, M.colors.bg},
            highlight = {M.colors.magenta, M.colors.bg}
        }
    }, {
        ShortPerCent = {
            provider = 'LinePercent',
            highlight = {M.colors.magenta, M.colors.bg}
        }
    }

}

gls.short_line_left = {
    {
        ShortFileIcon = {
            provider = 'FileIcon',
            condition = M.buffer_not_empty,
            highlight = {
                require('galaxyline.provider_fileinfo').get_file_icon_color,
                M.colors.bg
            }
        }
    }, {
        BufferType = {
            provider = 'FileName',
            separator = ' ',
            separator_highlight = {M.colors.bg, M.colors.bg},
            highlight = {M.colors.magenta, M.colors.bg}
        }
    }
}
