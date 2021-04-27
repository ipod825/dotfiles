local M = _G.plugin or {}
_G.plugin = M
local map = require'Vim'.map

-- Auto install packer.nvim if not exists
local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/opt/packer.nvim'
local should_install = vim.fn.empty(vim.fn.glob(install_path)) > 0
if should_install then
    vim.cmd('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
end
vim.cmd 'packadd packer.nvim'
vim.api.nvim_exec([[
    augroup PACKER
        autocmd!
        autocmd BufWritePost plugin.lua PackerCompile
        autocmd BufWritePost *.lua luafile %
    augroup END
]], false)

require'packer'.startup(function()
    use {'wbthomason/packer.nvim', opt = true}

    use {'rbtnn/vim-vimscript_lasterror', cmd = 'VimscriptLastError'}
    use {
        'simnalamburt/vim-mundo',
        cmd = 'MundoToggle',
        config = function()
            vim.o.undodir = vim.fn.stdpath('data') .. '/undo'
            vim.o.undofile = true
            vim.g.mnudo_width = math.floor(0.2 * vim.o.columns)
            vim.g.mundo_preview_height = math.floor(0.5 * vim.o.lines)
            vim.g.mundo_right = 1
            vim.cmd('augroup MUNDO')
            vim.cmd('autocmd!')
            vim.cmd('autocmd Filetype MundoDiff set wrap')
            vim.cmd('augroup END')
        end
    }

    use {
        'terrortylor/nvim-comment',
        config = function()
            require'nvim_comment'.setup({create_mapping = false})
        end
    }
    map("n", '<c-_>', "<cmd>CommentToggle<cr>")
    map("v", '<c-_>', ":<c-u>call CommentOperator(visualmode())<cr>")

    use {
        'nvim-treesitter/nvim-treesitter',
        disable = false,
        run = ':TSUpdate',
        requires = {
            'nvim-treesitter/nvim-treesitter-refactor'
            -- 'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            vim.api.nvim_exec([[
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        ]], false)
            require'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    'bash', 'bibtex', 'c', 'comment', 'cpp', 'css', 'fennel',
                    'go', 'html', 'javascript', 'json', 'jsonc', 'julia',
                    'latex', 'lua', 'python', 'rust', 'toml', 'typescript',
                    'yaml'
                },
                highlight = {enable = true},
                incremental_selection = {enable = false},
                indent = {enable = true}
            }
        end
    }
    -- use {'romgrk/nvim-treesitter-context', disable = true}
    use {
        'wellle/context.vim',
        cmd = 'ContextPeek',
        setup = function()
            vim.g.context_add_mappings = 0
            vim.g.context_enabled = 0
        end
    }
    map('n', '<m-i>', '<cmd>ContextPeek<cr>')

    use {
        'glepnir/zephyr-nvim',
        config = function() vim.cmd('colorscheme zephyr') end
    }

    use {
        'svermeulen/vim-yoink',
        config = function() vim.g.yoinkIncludeDeleteOperations = 1 end
    }
    use {'tpope/vim-abolish'}

    use {'junegunn/fzf', run = './install --all'}
    use {'junegunn/fzf.vim', config = function() require('fzf_cfg') end}

    use {'airblade/vim-rooter', setup = [[vim.g.rooter_manual_only = 1]]}

    use {'wsdjeg/vim-fetch'}
    use {'git@github.com:ipod825/vim-tabdrop'}

    use {
        'lambdalisue/gina.vim',
        config = function()
            vim.g['gina#action#index#discard_directories'] = 1
            vim.cmd(string.format('source %s',
                                  vim.fn.stdpath('config') .. '/ginasetup.vim'))
        end
    }

    use {'kyazdani42/nvim-web-devicons'}

    use {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        config = function() require 'statusline' end
    }

    use {'git@github.com:ipod825/msearch.vim', config = function() end}
    map('n', '8', '<Plug>MSToggleAddCword', {noremap = false})
    map('v', '8', '<Plug>MSToggleAddVisual', {noremap = false})
    map('n', '*', '<Plug>MSExclusiveAddCword', {noremap = false})
    map('v', '*', '<Plug>MSExclusiveAddVisual', {noremap = false})
    map('n', 'n', '<Plug>MSNext', {noremap = false})
    map('n', 'N', '<Plug>MSPrev', {noremap = false})
    map('o', 'n', '<Plug>MSNext', {noremap = false})
    map('o', 'N', '<Plug>MSPrev', {noremap = false})
    map('n', '<leader>n', '<Plug>MSToggleJump', {noremap = false})
    map('n', '<leader>/', '<Plug>MSClear', {noremap = false})
    map('n', '?', '<Plug>MSAddBySearchForward', {noremap = false})

    use {'fatih/vim-go', ft = 'go'}
    use {'voldikss/vim-translator', cmd = 'TranslateW'}

    use {'chaoren/vim-wordmotion', setup = [[vim.g.wordmotion_nomap = 1]]}
    map('n', 'w', '<Plug>WordMotion_w', {noremap = false})
    map('v', 'w', '<Plug>WordMotion_e', {noremap = false})
    map('o', 'w', '<Plug>WordMotion_e', {noremap = false})
    map('n', 'e', '<Plug>WordMotion_e', {noremap = false})
    map('v', 'e', '<Plug>WordMotion_e', {noremap = false})
    map('n', 'b', '<Plug>WordMotion_b', {noremap = false})
    map('v', 'b', '<Plug>WordMotion_b', {noremap = false})
    map('v', 'iv', '<Plug>WordMotion_iw', {noremap = false})
    map('o', 'iv', '<Plug>WordMotion_iw', {noremap = false})

    use {'drmikehenry/vim-headerguard', cmd = 'HeaderguardAdd'}

    use {
        'windwp/nvim-autopairs',
        config = function() require'nvim-autopairs'.setup() end
    }

    use {'tpope/vim-endwise'}

    use {
        'mg979/vim-visual-multi',
        branch = 'test',
        setup = function() vim.g.VM_default_mappings = 0 end,
        config = function()
            vim.g.VM_reselect_first = 1
            vim.g.VM_notify_previously_selected = 1
            vim.g.VM_theme = 'iceblue'

            vim.g.VM_custom_motions = {['<m-h>'] = '^', ['<m-l>'] = '$'}
            vim.g.VM_custom_noremaps = {
                ['])'] = '])',
                [']]'] = ']]',
                [']}'] = ']}',
                ['w'] = 'e'
            }
            vim.api.nvim_exec([[
            function! VM_Start()
                let @"=''
                imap <buffer> jk <Esc>
                imap <buffer> <c-h> <left>
                imap <buffer> <c-l> <right>
                imap <buffer> <c-j> <down>
                imap <buffer> <c-k> <up>
                imap <buffer> <m-h> <esc><m-h>i
                imap <buffer> <m-l> <esc><m-l>i
                nmap <buffer> J <down>
                nmap <buffer> K <up>
                nmap <buffer> H <Left>
                nmap <buffer> L <Right>
                nmap <buffer> <c-c> <Esc>
            endfun
    
            function! VM_Exit()
                iunmap <buffer> jk
                iunmap <buffer> <c-h>
                iunmap <buffer> <c-l>
                iunmap <buffer> <c-j>
                iunmap <buffer> <c-k>
                iunmap <buffer> <m-h>
                iunmap <buffer> <m-l>
                nunmap <buffer> J
                nunmap <buffer> K
                nunmap <buffer> H
                nunmap <buffer> L
                nunmap <buffer> <c-c>
            endfunction
    
            function! SelectAllMark()
                exec 'VMSearch '.msearch#joint_pattern()
                call feedkeys("\<Plug>(VM-Select-All)")
                call feedkeys("\<Plug>(VM-Goto-Prev)")
            endfunction
            function! VSelectAllMark()
                let [line_start, column_start] = getpos("'<")[1:2]
                let [line_end, column_end] = getpos("'>")[1:2]
                exec line_start.','.line_end-1.' VMSearch '.msearch#joint_pattern()
            endfunction
            function! VSelectAllMark()
                let [line_start, column_start] = getpos("'<")[1:2]
                let [line_end, column_end] = getpos("'>")[1:2]
                exec line_start.','.line_end.' VMSearch '.msearch#joint_pattern()
            endfunction
        ]], false)
        end
    }
    map('n', '<leader>r', '<cmd>call SelectAllMark()<cr>')
    map('v', '<leader>r', ':<c-u>call VSelectAllMark()<cr>')
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
        ['Visual Regex'] = '<leader>/',
        ["Add Cursor At Pos"] = '<c-i>',
        ['Visual Cursors'] = '<c-i>',
        ["Visual Reduce"] = '<leader>r',
        ['Increase'] = '+',
        ['Decrease'] = '-',
        ['Exit'] = '<Esc>'
    }

    use {
        'lukas-reineke/indent-blankline.nvim',
        branch = 'lua',
        config = function()
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indentLine_fileTypeExclude =
                {'tex', 'markdown', 'txt', 'startify', 'packer'}
        end
    }

    use {
        'hrsh7th/nvim-compe',
        disable = false,
        config = function()
            vim.g.loaded_compe_treesitter = true
            vim.g.loaded_compe_snippets_nvim = true
            vim.g.loaded_compe_spell = true
            vim.g.loaded_compe_tags = true
            vim.g.loaded_compe_ultisnips = true
            vim.g.loaded_compe_vim_lsc = true
            vim.g.loaded_compe_vim_lsp = true

            require('compe').setup {
                enabled = true,
                autocomplete = true,
                debug = false,
                min_length = 1,
                preselect = 'always',
                source = {
                    path = true,
                    buffer = true,
                    nvim_lsp = true,
                    nvim_lua = true,
                    vsnip = true
                }
            }
            vim.api.nvim_exec([[
            augroup COMPE
                autocmd!
                autocmd VimEnter * lua vim.defer_fn(function() vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', {expr=true}) end, 0)
            augroup END
        ]], false)
        end
    }

    use {'norcalli/nvim-colorizer.lua', config = [[require'colorizer'.setup()]]}

    use {
        'lervag/vimtex',
        ft = tex,
        config = function()
            vim.g.tex_flavor = 'latex'
            vim.g.vimtex_fold_enabled = 1
            vim.g.polyglot_disabled = {'latex'}
            vim.g.vimtex_log_ignore = {'25'}
            vim.g.vimtex_view_general_viewer = 'zathura'
            vim.g.tex_conceal = "abdgm"
            vim.api.nvim_exec([[
    augroup VIMTEX
        autocmd!
        if has("*deoplete#custom#var")
            autocmd Filetype tex call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
        endif
    augroup END
    ]], false)
        end
    }

    use {
        'hrsh7th/vim-vsnip',
        requires = {'hrsh7th/vim-vsnip-integ'},
        setup = function()
            vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') ..
                                          '/snippets/vsnip'
        end
    }
    map('i', '<tab>',
        'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<tab>"',
        {expr = true, noremap = false})
    map('i', '<s-tab>',
        'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"',
        {expr = true, noremap = false})
    map('s', '<tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<tab>"',
        {expr = true, noremap = false})
    map('s', '<s-tab>',
        'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"',
        {expr = true, noremap = false})

    use {'rhysd/vim-grammarous', cmd = 'GrammarousCheck'}

    use {'mfussenegger/nvim-dap', opt = true}
    use {'puremourning/vimspector', disable = true}

    use {'git@github.com:ipod825/julia-unicode.vim', ft = 'julia'}

    use {'junegunn/vim-easy-align'}
    map('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})
    map('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})

    use {'farmergreg/vim-lastplace'}

    use {
        'git@github.com:ipod825/war.vim',
        config = function()
            vim.api.nvim_exec([[
            augroup WAR
                autocmd!
                autocmd Filetype git call war#fire(-1, 0.8, -1, 0.1)
                autocmd Filetype esearch call war#fire(0.8, -1, 0.2, -1)
                autocmd Filetype bookmark call war#fire(-1, 1, -1, 0.2)
                autocmd Filetype bookmark call war#enter(-1)
            augroup END
        ]], false)
        end
    }

    use {'vim-test/vim-test'}

    use {
        'jalvesaq/vimcmdline',
        setup = function()
            vim.g.cmdline_map_start = '<LocalLeader>s'
            vim.g.cmdline_map_send = 'E'
            vim.g.cmdline_map_send_and_stay = '<LocalLeader>E'
        end
    }

    use {
        'kosayoda/nvim-lightbulb',
        config = function()
            vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
        end
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            SkipLspFns = SkipLspFns or {}
            local set_lsp = function(name, options)
                options = options or {}
                local lspconfig = require 'lspconfig'
                local client = lspconfig[name]
                client.setup(options)
                client.manager.orig_try_add = client.manager.try_add
                client.manager.try_add =
                    function(bufnr)
                        for _, skip_lsp in pairs(SkipLspFns) do
                            if skip_lsp() then return end
                        end
                        return client.manager.orig_try_add(bufnr)
                    end
            end
            set_lsp('pyls')
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
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim'}
                        },
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
    }

    use {
        'mhartington/formatter.nvim',
        config = function()
            local prettier = function()
                return {
                    exe = 'prettier',
                    args = {
                        '--stdin-filepath', vim.api.nvim_buf_get_name(0),
                        '--single-quote'
                    },
                    stdin = true
                }
            end
            local isort = function()
                return {exe = 'isort', args = {'-', '--quiet'}, stdin = true}
            end
            local yapf = function()
                return {exe = 'yapf', stdin = true}
            end
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
                    javascript = {prettier},
                    json = {prettier},
                    html = {prettier},
                    rust = {rustfmt},
                    python = {isort, yapf},
                    tex = {latexindent},
                    c = {clang_format},
                    cpp = {clang_format},
                    lua = {lua_format}
                }
            }
            vim.api.nvim_exec([[
            augroup FORMATTER
                autocmd!
                autocmd BufwritePre * FormatWrite
            augroup END
        ]], false)
        end
    }

    function M.goto_tag_or_lsp_def()
        if #(vim.fn.taglist(vim.fn.expand('<cword>'))) > 0 then
            vim.cmd('TabdropPushTag')
            vim.api.nvim_exec('silent! TagTabdrop', true)
        else
            vim.lsp.buf.definition()
        end
    end
    function M.lsp_goto(_, method, res)
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
    map('n', '<m-d>', '<cmd>lua plugin.goto_tag_or_lsp_def()<cr>')
    map('n', '<m-s>', '<cmd>TabdropPopTag<cr>')
    map('n', 'LH', '<cmd>lua vim.lsp.buf.hover()<cr>')
    map('n', 'LA', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    vim.lsp.handlers['textDocument/declaration'] = M.lsp_goto
    vim.lsp.handlers['textDocument/definition'] = M.lsp_goto
    vim.lsp.handlers['textDocument/typeDefinition'] = M.lsp_goto
    vim.lsp.handlers['textDocument/implementation'] = M.lsp_goto

    use {
        'terryma/vim-expand-region',
        requires = {
            {'kana/vim-textobj-user'}, {'sgur/vim-textobj-parameter'},
            {'kana/vim-textobj-line'}, {'machakann/vim-textobj-functioncall'},
            {'whatyouhide/vim-textobj-xmlattr', ft = {'html', 'xml'}}
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
                    ['a}'] = 1,
                    -- ['iB'] = 1,
                    -- ['aB'] = 1,
                    ['i,'] = 0,
                    ['a,'] = 0,
                    ['if'] = 0,
                    ['il'] = 0,
                    ['ip'] = 0,
                    ['ix'] = 0,
                    ['ax'] = 0
                }
        end
    }
    map('v', '<m-k>', '<Plug>(expand_region_expand)', {noremap = false})
    map('v', '<m-j>', '<Plug>(expand_region_shrink)', {noremap = false})
    map('n', '<m-k>', '<Plug>(expand_region_expand)', {noremap = false})
    map('n', '<m-j>', '<Plug>(expand_region_shrink)', {noremap = false})

    use {'majutsushi/tagbar'}
    use {'liuchengxu/vista.vim'}

    use {
        'git@github.com:ipod825/vim-bookmark',
        config = function()
            vim.g.bookmark_opencmd = 'NewTabdrop'
            vim.api.nvim_exec([[
        function! BookmarkContext()
            return [tagbar#currenttag("%s", "", "f"), getline('.')]
        endfunction
        let g:Bookmark_pos_context_fn = function('BookmarkContext')
        augroup BOOKMARK
            autocmd!
            autocmd Filetype bookmark nmap <buffer> <c-t> <cmd>call bookmark#open('Tabdrop')<cr>
        augroup END
        ]], false)
        end
    }
    map('n', "'", '<cmd>BookmarkGo netranger<cr>')
    map('n', "<leader>'", '<cmd>BookmarkGo<cr>')
    map('n', "<leader>m", '<cmd>BookmarkAddPos<cr>')

    use {'machakann/vim-sandwich'}
    use {
        'justinmk/vim-sneak',
        config = function()
            vim.g['sneak#label'] = 1
            vim.g['sneak#absolute_dir'] = -4
        end
    }
    map('n', 'f', '<Plug>Sneak_s', {noremap = false})
    map('n', 'F', '<Plug>Sneak_S', {noremap = false})

    use {'machakann/vim-swap'}

    use {
        'eugen0329/vim-esearch',
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
            vim.api.nvim_exec([[
        augroup ESEARCH
            autocmd!
            autocmd ColorScheme * highlight! link esearchMatch Cursor
            autocmd Filetype esearch silent! tabmove -1
        augroup END
        ]], false)
        end
    }
    map('n', '<leader>f', '<Plug>(operator-esearch-prefill)iw',
        {noremap = false})
    map('v', '<leader>f', '<Plug>(esearch)', {noremap = false})
    map('n', '<leader>F',
        '<cmd>call esearch#init({"prefill":["cword"], "paths": expand("%:p")})<cr>')
    map('v', '<leader>F', 'esearch#prefill({"paths": expand("%:p")})',
        {expr = true})

    use {'kkoomen/vim-doge'}
    use {'will133/vim-dirdiff'}

    use {'kevinhwang91/nvim-bqf'}
    use {
        'embear/vim-localvimrc',
        config = function() vim.g.localvimrc_ask = 0 end
    }

    use {'andymass/vim-matchup'}
    use {'AndrewRadev/linediff.vim'}

    use {
        'git@github.com:ipod825/vim-netranger',
        disable = false,
        setup = function()
            vim.g.NETRRifleFile = vim.env.HOME ..
                                      "/dotfiles/config/nvim/settings/rifle.conf"
            vim.g.NETRIgnore = {
                '__pycache__', '*.pyc', '*.o', 'egg-info', 'tags'
            }
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
            vim.api.nvim_exec([[
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
        ]], false)
        end
    }
end)

if should_install then vim.cmd('PackerSync') end
