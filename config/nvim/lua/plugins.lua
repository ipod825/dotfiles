local M = _G.plugins or {}
_G.plugins = M
local map = require'Vim'.map
local Plug = require('vplug')
local V = require('Vim')

Plug.begin()

Plug 'kyazdani42/nvim-web-devicons'
Plug('rbtnn/vim-vimscript_lasterror', {on_cmd = 'VimscriptLastError'})

Plug('terrortylor/nvim-comment', {
    branch = 'main',
    config = function()
        require'nvim_comment'.setup({
            comment_empty = true,
            create_mapping = false
        })
        map("n", '<c-_>', "<cmd>CommentToggle<cr>")
        map("v", '<c-_>', ":<c-u>call CommentOperator(visualmode())<cr>")
        V.augroup('COMMENT', {
            [[Filetype c,cpp setlocal commentstring=//\ %s]],
            [[Filetype *.xinitrc setlocal ft=sh | setlocal commentstring=#%s]]
        })
    end
})

Plug('nvim-treesitter/nvim-treesitter', {
    run = ':TSUpdate',
    config = function()
        vim.cmd([[
            set foldmethod=expr
            set foldexpr=nvim_treesitter#foldexpr()
            ]])
        require'nvim-treesitter.configs'.setup {
            ensure_installed = {
                'bash', 'bibtex', 'c', 'comment', 'cpp', 'css', 'fennel', 'go',
                'html', 'javascript', 'json', 'jsonc', 'julia', 'latex', 'lua',
                'python', 'rust', 'toml', 'typescript', 'yaml'
            },
            highlight = {enable = true},
            incremental_selection = {enable = false},
            indent = {enable = false}
        }
    end
})

Plug('lewis6991/spellsitter.nvim',
     {config = function() require('spellsitter').setup {enable = true} end})

Plug('nvim-treesitter/nvim-treesitter-textobjects', {
    config = function()
        require'nvim-treesitter.configs'.setup {
            textobjects = {
                select = {
                    enable = false,
                    keymaps = {
                        ["a,"] = "@parameter.outer",
                        ["i,"] = "@parameter.inner"
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_end = {
                        ["]]"] = "@function.outer",
                        ["]["] = "@class.outer"
                    },
                    goto_previous_start = {
                        ["[["] = "@function.outer",
                        ["[]"] = "@class.outer"
                    }
                }
            }
        }
    end
})

Plug('nvim-treesitter/playground', {
    on_cmd = 'TSPlaygroundToggle',
    config = function()
        require"nvim-treesitter.configs".setup {
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false -- Whether the query persists across vim sessions
            }
        }
    end
})
Plug('romgrk/nvim-treesitter-context', {disable = true})
Plug('haringsrob/nvim_context_vt')
Plug('wellle/context.vim', {
    on_cmd = 'ContextPeek',
    setup = function()
        vim.g.context_add_mappings = 0
        vim.g.context_enabled = 0
    end,
    config = function() map('n', '<m-i>', '<cmd>ContextPeek<cr>') end
})

Plug('svermeulen/vim-yoink',
     {config = function() vim.g.yoinkIncludeDeleteOperations = 1 end})
Plug('tpope/vim-abolish')

Plug('junegunn/fzf', {run = 'call fzf#install()'})
Plug('junegunn/fzf.vim', {config = function() require('fzf_cfg') end})

Plug('airblade/vim-rooter',
     {setup = function() vim.g.rooter_manual_only = 1 end})

Plug('wsdjeg/vim-fetch')
Plug('git@github.com:ipod825/vim-tabdrop')

Plug('jreybert/vimagit')

Plug('nvim-lua/plenary.nvim')
Plug('tanvirtin/vgit.nvim', {
    config = function()
        require('vgit').setup {settings = {live_gutter = {enabled = false}}}
    end
})
-- Plug('TimUntersberger/neogit')
Plug('lambdalisue/gina.vim', {
    config = function()
        vim.g['gina#action#index#discard_directories'] = 1
        vim.cmd(string.format('source %s',
                              vim.fn.stdpath('config') .. '/ginasetup.vim'))
    end
})

Plug('hoob3rt/lualine.nvim', {
    config = function()
        SkipStatusHeavyFns = SkipStatusHeavyFns or {}
        local enable_fn = function()
            for _, skip in pairs(SkipStatusHeavyFns) do
                if skip() then return false end
            end
            return true
        end
        local lualine_netranger = {
            sections = {
                lualine_a = {'mode'},
                lualine_b = {{'filename', file_status = false}},
                lualine_c = {{'branch', condition = enable_fn}}
            },
            filetypes = {'netranger'}
        }
        local lualine_gina = {
            sections = {
                lualine_a = {'mode'},
                lualine_b = {{'filename', file_status = false}},
                lualine_c = {
                    {
                        function()
                            return ' ' ..
                                       vim.fn.trim(
                                           vim.fn.system(
                                               'git branch --show-current'))
                        end,
                        condition = enable_fn
                    }
                }
            },
            filetypes = {'gina-status'}
        }
        require'lualine'.setup {
            options = {
                icons_enabled = true,
                theme = 'onedark',
                component_separators = {'', ''},
                section_separators = {'', ''},
                disabled_filetypes = {}
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'filename'},
                lualine_c = {
                    {'branch', condition = enable_fn}, {
                        'diagnostics',
                        sources = {'nvim_lsp'},
                        sections = {'error', 'warn', 'info', 'hint'},
                        color_error = '#ec5f67',
                        color_warn = '#fabd2f',
                        color_info = '#203663',
                        color_hint = '#203663',
                        symbols = {
                            error = '',
                            warn = '',
                            info = '',
                            hint = ''
                        }
                    }, {
                        'diff',
                        colored = true,
                        color_added = '#ec5f67',
                        color_modified = '#fabd2f',
                        color_removed = '#203663'
                    }
                },
                lualine_x = {'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {lualine_netranger, 'quickfix'}
        }
    end
})

Plug('git@github.com:ipod825/msearch.vim', {
    config = function()
        map('n', '8', '<Plug>MSToggleAddCword', {noremap = false})
        map('x', '8', '<Plug>MSToggleAddVisual', {noremap = false})
        map('n', '*', '<Plug>MSExclusiveAddCword', {noremap = false})
        map('x', '*', '<Plug>MSExclusiveAddVisual', {noremap = false})
        map('n', 'n', '<Plug>MSNext', {noremap = false})
        map('n', 'N', '<Plug>MSPrev', {noremap = false})
        map('o', 'n', '<Plug>MSNext', {noremap = false})
        map('o', 'N', '<Plug>MSPrev', {noremap = false})
        map('n', '<leader>n', '<Plug>MSToggleJump', {noremap = false})
        map('n', '<leader>/', '<Plug>MSClear', {noremap = false})
        map('n', '?', '<Plug>MSAddBySearchForward', {noremap = false})
    end
})

Plug('fatih/vim-go', {ft = 'go'})

Plug('voldikss/vim-translator', {cmd = 'TranslateW'})

Plug('chaoren/vim-wordmotion', {
    setup = function()
        vim.g.wordmotion_nomap = 1
        map('n', 'w', '<Plug>WordMotion_w', {noremap = false})
        map('x', 'w', '<Plug>WordMotion_e', {noremap = false})
        map('o', 'w', '<Plug>WordMotion_e', {noremap = false})
        map('n', 'e', '<Plug>WordMotion_e', {noremap = false})
        map('x', 'e', '<Plug>WordMotion_e', {noremap = false})
        map('n', 'b', '<Plug>WordMotion_b', {noremap = false})
        map('x', 'b', '<Plug>WordMotion_b', {noremap = false})
        map('x', 'iv', '<Plug>WordMotion_iw', {noremap = false})
        map('o', 'iv', '<Plug>WordMotion_iw', {noremap = false})
    end
})

Plug('windwp/nvim-autopairs',
     {config = function() require'nvim-autopairs'.setup() end})

-- Plug('anuvyklack/pretty-fold.nvim', {
--     config = function()
--         require('pretty-fold').setup {}
--         require('pretty-fold.preview').setup()
--     end
-- })

Plug('tpope/vim-endwise')

Plug('mg979/vim-visual-multi', {
    branch = 'test',
    utils = {
        SelectAllMark = function()
            vim.cmd('VMSearch ' .. vim.fn['msearch#joint_pattern']())
            V.feed_plug_keys("(VM-Select-All)")
            V.feed_plug_keys("(VM-Goto-Prev)")
        end,
        VSelectAllMark = function()
            local range = V.visual_range()
            vim.cmd(string.format('%d,%d VMSearch %s', range.line_beg,
                                  range.line_end,
                                  vim.fn['msearch#joint_pattern']()))
        end,
        VisualMultiStart = function()
            vim.fn.setreg('"', '')
            map('i', 'jk', '<Esc>', {buffer = true})
            map('i', '<c-h>', '<left>', {buffer = true})
            map('i', '<c-l>', '<right>', {buffer = true})
            map('i', '<c-j>', '<down>', {buffer = true})
            map('i', '<c-k>', '<up>', {buffer = true})
            map('i', '<m-h>', '<esc><m-h>i', {buffer = true})
            map('i', '<m-l>', '<esc><m-l>i', {buffer = true})
            map('n', 'J', '<down>', {buffer = true})
            map('n', 'K', '<up>', {buffer = true})
            map('n', 'H', '<Left>', {buffer = true})
            map('n', 'L', '<Right>', {buffer = true})
            map('n', '<c-c>', '<Esc>', {buffer = true})
        end,
        VisualMultiExit = function()
            V.unmap('i', 'jk', {buffer = true})
            V.unmap('i', '<c-h>', {buffer = true})
            V.unmap('i', '<c-l>', {buffer = true})
            V.unmap('i', '<c-j>', {buffer = true})
            V.unmap('i', '<c-k>', {buffer = true})
            V.unmap('i', '<m-h>', {buffer = true})
            V.unmap('i', '<m-l>', {buffer = true})
            V.unmap('n', 'J', {buffer = true})
            V.unmap('n', 'K', {buffer = true})
            V.unmap('n', 'H', {buffer = true})
            V.unmap('n', 'L', {buffer = true})
            V.unmap('n', '<c-c>', {buffer = true})
        end
    },
    setup = function()
        vim.g.VM_default_mappings = 0
        map('n', '<leader>r', '<cmd>lua plug.utils.SelectAllMark()<cr>')
        map('x', '<leader>r', ':<c-u>lua plug.utils.VSelectAllMark()<cr>')
        vim.g.VM_maps = {
            ["Switch Mode"] = 'v',
            ['Find Word'] = '<c-n>',
            ['Skip Region'] = '<c-x>',
            ['Remove Region'] = '<c-p>',
            ['Goto Prev'] = '<c-k>',
            ['Goto Next'] = '<c-j>',
            ['Undo'] = 'u',
            ['Redo'] = '<c-r>',
            ['Case Conversion Menu'] = '<leader>c',
            ['Numbers'] = '<leader>n',
            ['Visual Add'] = '<c-n>',
            ['Visual Find'] = '<c-n>',
            ["Add Cursor At Pos"] = '<c-i>',
            ['Visual Cursors'] = '<c-i>',
            ["Visual Reduce"] = '<leader>r',
            ["Visiual Subtract"] = '<leader>s',
            ['Increase'] = '+',
            ['Decrease'] = '-',
            ['Exit'] = '<Esc>',
            ['Transpose'] = '<leader>t',
            ['Case conversion'] = '<leader>c',
            ['Go-to-regex motion'] = '\\g',
            ['Toggle Single Region'] = '\\<cr>',
            -- Not used in my flow
            ['Visual Regex'] = '<leader>/'
        }
    end,
    config = function()
        vim.g.VM_reselect_first = 1
        vim.g.VM_notify_previously_selected = 1
        vim.g.VM_theme = 'iceblue'

        vim.g.VM_custom_motions = {['<m-h>'] = '^', ['<m-l>'] = '$'}
        vim.g.VM_custom_noremaps = {
            ['])'] = '])',
            [']]'] = ']]',
            [']}'] = '])',
            ['w'] = 'e'
        }
        V.augroup('VISUAL-MULTI', {
            [[User visual_multi_start lua plug.utils.VisualMultiStart()]],
            [[User visual_multi_exit  lua plug.utils.VisualMultiExit()]]
        })
    end
})

Plug('lukas-reineke/indent-blankline.nvim', {
    config = function()
        vim.g.indent_blankline_use_treesitter = true
        vim.g.indentLine_fileTypeExclude =
            {'tex', 'markdown', 'txt', 'startify', 'packer'}
    end
})

Plug('hrsh7th/cmp-buffer', {branch = 'main'})
Plug('hrsh7th/cmp-nvim-lsp', {branch = 'main'})
Plug('hrsh7th/cmp-vsnip', {branch = 'main'})
Plug('hrsh7th/cmp-path', {branch = 'main'})
Plug('hrsh7th/cmp-nvim-lua', {branch = 'main'})
Plug('f3fora/cmp-spell')
Plug('hrsh7th/cmp-cmdline', {branch = 'main'})
Plug('hrsh7th/nvim-cmp', {
    branch = 'main',
    config = function()
        local cmp = require 'cmp'
        cmp.setup({
            completion = {completeopt = 'menu,menuone,noinsert'},
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                end
            },
            mapping = {
                ['<c-j>'] = cmp.mapping.select_next_item(
                    {behavior = cmp.SelectBehavior.Insert}),
                ['<c-k>'] = cmp.mapping.select_prev_item(
                    {behavior = cmp.SelectBehavior.Insert}),
                ['<c-n>'] = cmp.mapping.select_next_item(
                    {behavior = cmp.SelectBehavior.Insert}),
                ['<c-p>'] = cmp.mapping.select_prev_item(
                    {behavior = cmp.SelectBehavior.Insert}),
                ['<c-d>'] = cmp.mapping.scroll_docs(-4),
                ['<c-f>'] = cmp.mapping.scroll_docs(4),
                ['<c-c>'] = cmp.mapping.close(),
                ['<cr>'] = cmp.mapping.confirm({select = true})
            },
            sources = cmp.config.sources(
                {
                    {name = 'buffer'}, {name = 'nvim_lsp'}, {name = 'vsnip'},
                    {name = 'spell'}
                })
        })
        cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})
    end
})

Plug('norcalli/nvim-colorizer.lua',
     {config = function() require'colorizer'.setup() end})

Plug('lervag/vimtex', {
    ft = 'tex',
    config = function()
        vim.g.tex_flavor = 'latex'
        vim.g.vimtex_fold_enabled = 1
        vim.g.polyglot_disabled = {'latex'}
        vim.g.vimtex_log_ignore = {'25'}
        vim.g.vimtex_view_general_viewer = 'zathura'
        vim.g.tex_conceal = "abdgm"
        if vim.fn.has("*deoplete#custom#var") then
            V.augroup('VIMTEX', {
                [[Filetype tex call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})]],
                [[Filetype *.tex,*.md,*.adoc setlocal spell]],
                [[Filetype *.tex setlocal nocursorline]],
                [[Filetype *.tex setlocal wildignore+=*.aux,*.fls,*.blg,*.pdf,*.log,*.out,*.bbl,*.fdb_latexmk]],
                [[Filetype *.md,*.tex inoremap <buffer> sl \]],
                [[Filetype *.md,*.tex inoreabbrev <buffer> an &]],
                [[Filetype *.md,*.tex inoreabbrev <buffer> da $$<Left>]],
                [[Filetype *.md,*.tex inoreabbrev <buffer> pl +]],
                [[Filetype *.md,*.tex inoreabbrev <buffer> mi -]],
                [[Filetype *.md,*.tex inoreabbrev <buffer> eq =]],
                [[Filetype *.md,*.tex inoremap <buffer> <M-j> _]],
                [[Filetype *.md,*.tex inoremap <buffer> <M-j> _]],
                [[Filetype *.md,*.tex inoremap <buffer> <M-k> ^]],
                [[Filetype *.md,*.tex inoremap <buffer> <M-q> {}<Left>]] -- Comment
            })
        end
    end
})

Plug('hrsh7th/vim-vsnip-integ')
Plug('hrsh7th/vim-vsnip', {
    setup = function()
        vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets/vsnip'
    end,
    config = function()
        map('i', '<tab>',
            'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<tab>"',
            {expr = true, noremap = false})
        map('i', '<s-tab>',
            'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"',
            {expr = true, noremap = false})
        map('s', '<tab>',
            'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<tab>"',
            {expr = true, noremap = false})
        map('s', '<s-tab>',
            'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"',
            {expr = true, noremap = false})
    end
})

Plug('rhysd/vim-grammarous', {on_cmd = 'GrammarousCheck'})

Plug('mfussenegger/nvim-dap')
Plug('puremourning/vimspector')

Plug('git@github.com:ipod825/julia-unicode.vim', {ft = 'julia'})

Plug('junegunn/vim-easy-align', {
    config = function()
        map('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})
        map('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})
    end
})

Plug('farmergreg/vim-lastplace')

Plug('git@github.com:ipod825/war.vim', {
    config = function()
        V.augroup('WAR', {
            [[Filetype git call war#fire(-1, 0.8, -1, 0.1)]],
            [[Filetype esearch call war#fire(0.8, -1, 0.2, -1)]],
            [[Filetype bookmark call war#fire(-1, 1, -1, 0.2)]],
            [[Filetype bookmark call war#enter(-1)]]
        })
    end
})

Plug('vim-test/vim-test', {disable = true})

Plug('voldikss/vim-floaterm', {
    utils = {
        StartRepl = function()
            local ori_win = vim.api.nvim_get_current_win()
            local repl_loopup = {python = 'ipython', sh = 'zsh', zsh = 'zsh'}
            local ft = vim.api.nvim_buf_get_option(0, 'ft')
            if repl_loopup[ft] then
                vim.cmd('FloatermNew ' .. repl_loopup[ft])
            else
                vim.notify('No repl for ' .. ft, vim.log.levels.ERROR)
            end
            vim.api.nvim_set_current_win(ori_win)
            vim.cmd('stopinsert')
        end,
        SendReplLine = function()
            vim.cmd(string.format('FloatermSend %s', vim.fn.getline('.')))
            vim.cmd('normal! j')
        end
    },
    config = function()
        vim.g.floaterm_wintype = 'vsplit'
        vim.g.floaterm_position = 'botright'
        vim.g.floaterm_width = 0.5
        vim.g.floaterm_height = 0.5
        map('n', '\\s', '<cmd>lua plug.utils.StartRepl()<cr>')
    end
})

Plug('kosayoda/nvim-lightbulb', {
    config = function()
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end
})

Plug('git@github.com:ipod825/nvim-bqf', {
    branch = 'main',
    ft = 'qf',
    config = function()
        require('bqf').setup({
            qf_win_option = {
                wrap = true,
                number = false,
                relativenumber = false
            },
            preview = {win_height = 50}
        })
    end
})

Plug('neovim/nvim-lspconfig', {
    config = function()
        SkipLspFns = SkipLspFns or {}
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

        local set_lsp = function(name, options)
            options = options or {capabilities = capabilities}
            local lspconfig = require 'lspconfig'
            local client = lspconfig[name]
            client.setup(options)
            client.manager.orig_try_add = client.manager.try_add
            client.manager.try_add = function(bufnr)
                for _, skip_lsp in pairs(SkipLspFns) do
                    if skip_lsp() then return end
                end
                return client.manager.orig_try_add(bufnr)
            end
        end
        set_lsp('pylsp')
        set_lsp('clangd')
        set_lsp('gopls')
        set_lsp('rls')
        local sumneko_root_path = vim.env.XDG_DATA_HOME ..
                                      '/lua-language-server'
        local sumneko_binary = sumneko_root_path ..
                                   '/bin/Linux/lua-language-server'
        set_lsp('sumneko_lua', {
            cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        -- Setup your lua path
                        path = vim.split(package.path, ';')
                    },
                    diagnostics = {globals = {'vim'}},
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = {
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                        }
                    }
                }
            }
        })
    end
})

Plug('mhartington/formatter.nvim', {
    config = function()
        local isort = function()
            return {exe = 'isort', args = {'-', '--quiet'}, stdin = true}
        end
        local yapf = function() return {exe = 'yapf', stdin = true} end
        local rustfmt = function()
            return {exe = 'rustfmt', args = {'--emit=stdout'}, stdin = true}
        end
        local latexindent = function()
            return {
                exe = 'latexindent',
                args = {'-sl', '-g /dev/stderr', '2>/dev/null'},
                stdin = true
            }
        end
        local clang_format = function()
            return {
                exe = 'clang-format',
                args = {'-assume-filename=' .. vim.fn.expand('%:t')},
                stdin = true
            }
        end
        local lua_format = function()
            return {exe = 'lua-format', stdin = true}
        end
        require('formatter').setup {
            logging = false,
            filetype = {
                rust = {rustfmt},
                python = {isort, yapf},
                tex = {latexindent},
                c = {clang_format},
                cpp = {clang_format},
                lua = {lua_format}
            }
        }
        V.augroup('FORMATTER', {[[BufwritePost * silent! FormatWrite]]})
    end
})

Plug('kana/vim-textobj-user')
Plug('kana/vim-textobj-line')
Plug('machakann/vim-textobj-functioncall')
Plug('sgur/vim-textobj-parameter')
Plug('whatyouhide/vim-textobj-xmlattr', {ft = {'html', 'xml'}})
Plug('git@github.com:ipod825/vim-expand-region', {
    utils = {
        ExpandRegionStart = function()
            Vim.unmap('n', '8')
            Vim.unmap('x', '8')
        end,
        ExpandRegionStop = function()
            map('n', '8', '<Plug>MSToggleAddCword', {noremap = false})
            map('x', '8', '<Plug>MSToggleAddVisual', {noremap = false})
        end
    },
    setup = function()
        vim.g.vim_textobj_parameter_mapping = ','
        vim.g.expand_region_text_objects =
            {
                ['iw'] = 0,
                ['i"'] = 0,
                ['a"'] = 0,
                ["i'"] = 0,
                ["a'"] = 0,
                ['i]'] = 1,
                ['a]'] = 1,
                ['i)'] = 1,
                ['a)'] = 1,
                ['i}'] = 1,
                ['i,'] = 0,
                ['a,'] = 0,
                ['if'] = 0,
                ['il'] = 0,
                ['ip'] = 0,
                ['ix'] = 0,
                ['ax'] = 0
            }
    end,
    config = function()
        Vim.augroup('EXPANDREGION', {
            [[USER ExpandRegionStart lua plug.utils.ExpandRegionStart()]],
            [[USER ExpandRegionStop lua plug.utils.ExpandRegionStop()]]
        })
        map('x', '<m-k>', '<Plug>(expand_region_expand)', {noremap = false})
        map('x', '<m-j>', '<Plug>(expand_region_shrink)', {noremap = false})
        map('n', '<m-k>', '<Plug>(expand_region_expand)', {noremap = false})
        map('n', '<m-j>', '<Plug>(expand_region_shrink)', {noremap = false})
    end
})

Plug('majutsushi/tagbar')

Plug('git@github.com:ipod825/vim-bookmark', {
    config = function()
        vim.g.bookmark_opencmd = 'NewTabdrop'
        vim.g.Bookmark_pos_context_fn = function()
            return {
                vim.fn['tagbar#currenttag']("%s", "", "f"), vim.fn.getline('.')
            }
        end
        V.augroup('BOOKMARK', {
            [[Filetype bookmark nmap <buffer> <c-t> <cmd>call bookmark#open('Tabdrop')<cr>]]
        })
        map('n', "'", '<cmd>BookmarkGo netranger<cr>')
        map('n', "<leader>'", '<cmd>BookmarkGo<cr>')
        map('n', "<leader>m", '<cmd>BookmarkAddPos<cr>')
    end
})

Plug('machakann/vim-sandwich')
Plug('justinmk/vim-sneak', {
    config = function()
        vim.g['sneak#label'] = 1
        vim.g['sneak#absolute_dir'] = -4
        map('n', 'f', '<Plug>Sneak_s', {noremap = false})
        map('n', 'F', '<Plug>Sneak_S', {noremap = false})
    end
})

Plug('machakann/vim-swap')

Plug('eugen0329/vim-esearch', {
    branch = 'development',
    setup = function()
        vim.g.esearch = {
            adapter = 'rg',
            bckend = 'nvim',
            out = 'win',
            batch_size = 1000,
            default_mappings = 0,
            live_update = 0,
            win_ui_nvim_syntax = 1,
            remember = {
                'case', 'regex', 'filetypes', 'before', 'after', 'context'
            },
            win_map = {
                {'n', '<cr>', '<cmd>call b:esearch.open("NewTabdrop")<cr>'},
                {'n', 't', '<cmd>call b:esearch.open("NETRTabdrop")<cr>'},
                {
                    'n', 'pp',
                    '<cmd>call b:esearch.split_preview_open() | wincmd W<cr>'
                },
                {
                    'n', 'R',
                    '<cmd>call b:esearch.reload({"backend": "system"})<cr>'
                }
            }

        }
    end,
    config = function()
        V.augroup('ESEARCH', {
            [[ColorScheme * highlight! link esearchMatch Cursor]],
            [[Filetype esearch silent! tabmove -1]]
        })
        map('n', '<leader>f', '<Plug>(operator-esearch-prefill)iw',
            {noremap = false})
        map('x', '<leader>f', '<Plug>(esearch)', {noremap = false})
        map('n', '<leader>F',
            '<cmd>call esearch#init({"prefill":["cword"], "paths": expand("%:p")})<cr>')
        map('x', '<leader>F', 'esearch#prefill({"paths": expand("%:p")})',
            {expr = true})
    end

})

Plug('kkoomen/vim-doge', {disable = true})
Plug('will133/vim-dirdiff', {on_cmd = 'DirDiff'})

Plug('skywind3000/asyncrun.vim', {
    utils = {
        AsyncrunPre = function()
            vim.cmd('wincmd o')
            vim.g.asyncrun_win = vim.api.nvim_get_current_win()
        end,
        AsyncrunCallback = function()
            vim.api.nvim_set_current_win(vim.g.asyncrun_win)
            if vim.g.asyncrun_code == 0 then
                vim.cmd('cclose')
            else
                vim.fn.setqflist(vim.tbl_filter(
                                     function(e)
                        return e.valid ~= 0
                    end, vim.fn.getqflist()), 'r')
                vim.cmd('botright copen')
            end
            vim.fn.system([[zenity --info --text Done --display=$DISPLAY]])
        end
    },
    config = function()
        vim.g.asyncrun_pathfix = 1
        vim.g.asyncrun_open = 6
        vim.g.asyncrun_exit = 'lua plug.utils.AsyncrunCallback()'
        V.augroup('PACKER', {[[User AsyncRunPre lua plug.utils.AsyncrunPre()]]})
    end
})

Plug('skywind3000/asynctasks.vim', {
    config = function()
        vim.g.asynctasks_term_reuse = 1
        vim.g.asynctasks_confirm = 0
    end
})

Plug('git@github.com:ipod825/igit.nvim', {
    branch = 'main',
    config = function()
        local igit = require 'igit'
        vim.cmd('cnoreabbrev G lua require"igit".status:open()')
        vim.cmd('cnoreabbrev gbr lua require"igit".branch:open()')
        local igit = require('igit')
        igit.setup({
            branch = {mapping = {n = {['a'] = function() print(1) end}}}
        })
    end
})

Plug('andymass/vim-matchup')
Plug('AndrewRadev/linediff.vim', {on_cmd = {'LineDiffAdd'}})

Plug('git@github.com:ipod825/vim-netranger', {
    setup = function()
        vim.g.NETRRifleFile = vim.env.HOME ..
                                  "/dotfiles/config/nvim/settings/rifle.conf"
        vim.g.NETRIgnore = {'__pycache__', '*.pyc', '*.o', 'egg-info', 'tags'}
        vim.g.NETRColors = {dir = 39, footer = 35, exe = 35}
        vim.g.NETRGuiColors = {
            dir = '#00afff',
            footer = '#00af5f',
            exe = '#00af5f'
        }
        vim.g.NETRRifleDisplayError = false
        vim.g.NETRDefaultMapSkip = {'<cr>'}
    end,
    config = function()
        vim.cmd([[
          function! DuplicateNode()
              let path = netranger#api#cur_node_path()
              if isdirectory(path)
                  let dir = fnamemodify(path, ':p:h:h')
                  let newname = 'DUP'.fnamemodify(path[:-1], ':t')
              else
                  let dir = fnamemodify(path, ':p:h')
                  let newname = 'DUP'.fnamemodify(path, ':p:t')
              endif
              echom dir
              call netranger#api#cp(path, dir.'/'.newname)
          endfunction
          function! NETRBookMark()
              BookmarkAdd netranger
          endfunction
      
          function! NETRBookMarkGo()
              BookmarkGo netranger
          endfunction
      
          function! NETRInit()
              call netranger#api#mapvimfn('yp', "DuplicateNode")
              call netranger#api#mapvimfn('m', "NETRBookMark")
              call netranger#api#mapvimfn("\'", "NETRBookMarkGo")
          endfunction
      
          let g:NETRCustomNopreview={->winnr()==2 && winnr('$')==2}
      
          autocmd! USER NETRInit call NETRInit()
          ]])
    end
})

Plug.ends()

return M