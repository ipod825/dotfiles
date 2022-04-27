local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.api.nvim_exec(
	[[
    augroup PACKER
        autocmd!
        autocmd BufWritePost plugin.lua source <afile> | PackerCompile
    augroup END
]],
	false
)

require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "rbtnn/vim-vimscript_lasterror", cmd = "VimscriptLastError" })

	use({
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({
				comment_empty = true,
				create_mapping = false,
			})
		end,
	})
	map("n", "<c-_>", "<cmd>CommentToggle<cr>")
	map("v", "<c-_>", ":<c-u>call CommentOperator(visualmode())<cr>")

	use({
		"nvim-treesitter/nvim-treesitter",
		disable = false,
		run = ":TSUpdate",
		config = function()
			vim.api.nvim_exec(
				[[
           set foldmethod=expr
           set foldexpr=nvim_treesitter#foldexpr()
           ]],
				false
			)
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"bibtex",
					"c",
					"comment",
					"cpp",
					"css",
					"fennel",
					"go",
					"html",
					"javascript",
					"json",
					"jsonc",
					"julia",
					"latex",
					"lua",
					"python",
					"rust",
					"toml",
					"typescript",
					"yaml",
				},
				highlight = { enable = true },
				incremental_selection = { enable = false },
				indent = { enable = false },
			})
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		disable = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = false,
						keymaps = {
							["a,"] = "@parameter.outer",
							["i,"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_end = {
							["]]"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	})

	use({
		"nvim-treesitter/playground",
		disable = true,
		config = function()
			require("nvim-treesitter.configs").setup({
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
				},
			})
		end,
	})
	use({ "romgrk/nvim-treesitter-context", disable = true })
	use({ "haringsrob/nvim_context_vt" })
	use({
		"wellle/context.vim",
		cmd = "ContextPeek",
		setup = function()
			vim.g.context_add_mappings = 0
			vim.g.context_enabled = 0
		end,
	})
	map("n", "<m-i>", "<cmd>ContextPeek<cr>")

	use({
		"lewis6991/spellsitter.nvim",
		disable = true,
		config = function()
			require("spellsitter").setup()
		end,
	})

	use({
		"svermeulen/vim-yoink",
		config = function()
			vim.g.yoinkIncludeDeleteOperations = 1
		end,
	})
	use({ "tpope/vim-abolish" })

	use({ "junegunn/fzf", run = "./install --all" })
	use({
		"junegunn/fzf.vim",
		config = function()
			require("fzf_cfg")
		end,
	})

	use({ "airblade/vim-rooter", setup = [[vim.g.rooter_manual_only = 1]] })

	use({ "wsdjeg/vim-fetch" })
	use({ "git@github.com:ipod825/vim-tabdrop" })

	use({
		"lambdalisue/gina.vim",
		config = function()
			vim.g["gina#action#index#discard_directories"] = 1
			vim.cmd(string.format("source %s", vim.fn.stdpath("config") .. "/ginasetup.vim"))
		end,
	})

	use({
		"hoob3rt/lualine.nvim",
		config = function()
			SkipStatusHeavyFns = SkipStatusHeavyFns or {}
			local enable_fn = function()
				for _, skip in pairs(SkipStatusHeavyFns) do
					if skip() then
						return false
					end
				end
				return true
			end
			local my_extension = {
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "filename", file_status = false } },
					lualine_c = { { "branch", condition = enable_fn } },
				},
				filetypes = { "netranger" },
			}
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "onedark",
					component_separators = { "", "" },
					section_separators = { "", "" },
					disabled_filetypes = {},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = {
						{ "branch", condition = enable_fn },
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							sections = { "error", "warn", "info", "hint" },
							color_error = "#ec5f67",
							color_warn = "#fabd2f",
							color_info = "#203663",
							color_hint = "#203663",
							symbols = {
								error = "",
								warn = "",
								info = "",
								hint = "",
							},
						},
						{
							"diff",
							colored = true,
							color_added = "#ec5f67",
							color_modified = "#fabd2f",
							color_removed = "#203663",
						},
					},
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = { my_extension, "quickfix" },
			})
		end,
	})

	use({ "git@github.com:ipod825/msearch.vim", config = function() end })
	map("n", "8", "<Plug>MSToggleAddCword", { remap = true })
	map("x", "8", "<Plug>MSToggleAddVisual", { remap = true })
	map("n", "*", "<Plug>MSExclusiveAddCword", { remap = true })
	map("x", "*", "<Plug>MSExclusiveAddVisual", { remap = true })
	map("n", "n", "<Plug>MSNext", { remap = true })
	map("n", "N", "<Plug>MSPrev", { remap = true })
	map("o", "n", "<Plug>MSNext", { remap = true })
	map("o", "N", "<Plug>MSPrev", { remap = true })
	map("n", "<leader>n", "<Plug>MSToggleJump", { remap = true })
	map("n", "<leader>/", "<Plug>MSClear", { remap = true })
	map("n", "?", "<Plug>MSAddBySearchForward", { remap = true })

	use({ "fatih/vim-go", ft = "go" })
	use({ "voldikss/vim-translator", cmd = "TranslateW" })

	use({ "chaoren/vim-wordmotion", setup = [[vim.g.wordmotion_nomap = 1]] })
	map("n", "w", "<Plug>WordMotion_w", { remap = true })
	map("x", "w", "<Plug>WordMotion_e", { remap = true })
	map("o", "w", "<Plug>WordMotion_e", { remap = true })
	map("n", "e", "<Plug>WordMotion_e", { remap = true })
	map("x", "e", "<Plug>WordMotion_e", { remap = true })
	map("n", "b", "<Plug>WordMotion_b", { remap = true })
	map("x", "b", "<Plug>WordMotion_b", { remap = true })
	map("x", "iv", "<Plug>WordMotion_iw", { remap = true })
	map("o", "iv", "<Plug>WordMotion_iw", { remap = true })

	use({ "drmikehenry/vim-headerguard", cmd = "HeaderguardAdd" })

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})

	use({ "tpope/vim-endwise" })

	use({
		"mg979/vim-visual-multi",
		branch = "test",
		setup = function()
			vim.g.VM_default_mappings = 0
		end,
		config = function()
			vim.g.VM_reselect_first = 1
			vim.g.VM_notify_previously_selected = 1
			vim.g.VM_theme = "iceblue"

			vim.g.VM_custom_motions = { ["<m-h>"] = "^", ["<m-l>"] = "$" }
			vim.g.VM_custom_noremaps = {
				["])"] = "])",
				["]]"] = "]]",
				["]}"] = "]}",
				["w"] = "e",
			}
			vim.api.nvim_exec(
				[[
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
        ]],
				false
			)
		end,
	})
	map("n", "<leader>r", "<cmd>call SelectAllMark()<cr>")
	map("x", "<leader>r", ":<c-u>call VSelectAllMark()<cr>")
	vim.g.VM_maps = {
		["Switch Mode"] = "v",
		["Find Word"] = "<c-n>",
		["Skip Region"] = "<c-x>",
		["Remove Region"] = "<c-p>",
		["Goto Prev"] = "<c-k>",
		["Goto Next"] = "<c-j>",
		["Undo"] = "u",
		["Redo"] = "<c-r>",
		["Case Conversion Menu"] = "<leader>c",
		["Numbers"] = "<leader>n",
		["Visual Add"] = "<c-n>",
		["Visual Find"] = "<c-n>",
		["Visual Regex"] = "<leader>/",
		["Add Cursor At Pos"] = "<c-i>",
		["Visual Cursors"] = "<c-i>",
		["Visual Reduce"] = "<leader>r",
		["Increase"] = "+",
		["Decrease"] = "-",
		["Exit"] = "<Esc>",
	}

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.g.indent_blankline_use_treesitter = true
			vim.g.indentLine_fileTypeExclude = { "tex", "markdown", "txt", "startify", "packer" }
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-cmdline" },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				completion = { completeopt = "menu,menuone,noinsert" },
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					end,
				},
				mapping = {
					["<c-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<c-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<c-d>"] = cmp.mapping.scroll_docs(-4),
					["<c-f>"] = cmp.mapping.scroll_docs(4),
					["<c-c>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "vsnip" },
					{ name = "spell" },
				}),
			})
			cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
		end,
	})

	use({
		"norcalli/nvim-colorizer.lua",
		disable = false,
		config = [[require'colorizer'.setup()]],
	})

	use({
		"lervag/vimtex",
		ft = tex,
		config = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_fold_enabled = 1
			vim.g.polyglot_disabled = { "latex" }
			vim.g.vimtex_log_ignore = { "25" }
			vim.g.vimtex_view_general_viewer = "zathura"
			vim.g.tex_conceal = "abdgm"
			vim.api.nvim_exec(
				[[
    augroup VIMTEX
        autocmd!
        if has("*deoplete#custom#var")
            autocmd Filetype tex call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
        endif
    augroup END
    ]],
				false
			)
		end,
	})

	use({
		"hrsh7th/vim-vsnip",
		requires = { "hrsh7th/vim-vsnip-integ" },
		setup = function()
			vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets/vsnip"
		end,
	})
	map("i", "<tab>", 'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<tab>"', { expr = true, remap = true })
	map("i", "<s-tab>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true, remap = true })
	map("s", "<tab>", 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<tab>"', { expr = true, remap = true })
	map("s", "<s-tab>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true, remap = true })

	use({ "rhysd/vim-grammarous", cmd = "GrammarousCheck" })

	use({ "mfussenegger/nvim-dap", opt = true })
	use({ "puremourning/vimspector", disable = true })

	use({ "git@github.com:ipod825/julia-unicode.vim", ft = "julia" })

	use({ "junegunn/vim-easy-align" })
	map("n", "ga", "<Plug>(EasyAlign)", { remap = true })
	map("x", "ga", "<Plug>(EasyAlign)", { remap = true })

	use({ "farmergreg/vim-lastplace" })

	use({ "michaelb/sniprun", run = "bash ./install.sh" })

	use({
		"git@github.com:ipod825/war.vim",
		config = function()
			vim.api.nvim_exec(
				[[
            augroup WAR
                autocmd!
                autocmd Filetype git call war#fire(-1, 0.8, -1, 0.1)
                autocmd Filetype esearch call war#fire(0.8, -1, 0.2, -1)
                autocmd Filetype bookmark call war#fire(-1, 1, -1, 0.2)
                autocmd Filetype bookmark call war#enter(-1)
            augroup END
        ]],
				false
			)
		end,
	})

	use({ "vim-test/vim-test", opt = true })
	use({ "rcarriga/vim-ultest", opt = true })

	use({
		"jalvesaq/vimcmdline",
		config = function()
			vim.g.cmdline_vsplit = 1
			vim.g.cmdline_map_start = "<leader>s"
			vim.g.cmdline_map_send = "E"
			vim.g.cmdline_map_send_and_stay = "<LocalLeader>E"
			vim.g.cmdline_app = {
				matlab = "matlab -nojvm -nodisplay -nosplash",
				python = "ipython",
				sh = "zsh",
				zsh = "zsh",
				lua = "ilua",
			}
		end,
	})

	use({
		"kosayoda/nvim-lightbulb",
		config = function()
			vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
		end,
	})

	use({
		"git@github.com:ipod825/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				qf_win_option = {
					wrap = true,
					number = false,
					relativenumber = false,
				},
				preview = { win_height = 50 },
			})
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			SkipLspFns = SkipLspFns or {}
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

			local set_lsp = function(name, options)
				options = options or { capabilities = capabilities }
				local lspconfig = require("lspconfig")
				local client = lspconfig[name]
				client.setup(options)
				client.manager.orig_try_add = client.manager.try_add
				client.manager.try_add = function(bufnr)
					for _, skip_lsp in pairs(SkipLspFns) do
						if skip_lsp() then
							return
						end
					end
					return client.manager.orig_try_add(bufnr)
				end
			end
			set_lsp("pylsp")
			set_lsp("clangd")
			set_lsp("gopls")
			set_lsp("rls")
			local sumneko_root_path = vim.env.XDG_DATA_HOME .. "/lua-language-server"
			local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"
			set_lsp("sumneko_lua", {
				cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							-- Setup your lua path
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
						},
					},
				},
			})
		end,
	})

	use({
		"mhartington/formatter.nvim",
		config = function()
			local prettier = function()
				return {
					exe = "prettier",
					args = {
						"--stdin-filepath",
						vim.api.nvim_buf_get_name(0),
						"--single-quote",
					},
					stdin = true,
				}
			end
			local isort = function()
				return { exe = "isort", args = { "-", "--quiet" }, stdin = true }
			end
			local yapf = function()
				return { exe = "yapf", stdin = true }
			end
			local rustfmt = function()
				return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true }
			end
			local latexindent = function()
				return {
					exe = "latexindent",
					args = { "-sl", "-g /dev/stderr", "2>/dev/null" },
					stdin = true,
				}
			end
			local clang_format = function()
				return {
					exe = "clang-format",
					args = { "-assume-filename=" .. vim.fn.expand("%:t") },
					stdin = true,
				}
			end
			local lua_format = function()
				return { exe = "lua-format", stdin = true }
			end
			require("formatter").setup({
				logging = false,
				filetype = {
					-- javascript = {prettier},
					-- json = {prettier},
					-- html = {prettier},
					rust = { rustfmt },
					python = { isort, yapf },
					tex = { latexindent },
					c = { clang_format },
					cpp = { clang_format },
					lua = { lua_format },
				},
			})
			vim.api.nvim_exec(
				[[
            augroup FORMATTER
                autocmd!
                autocmd BufwritePost * silent! FormatWrite
            augroup END
        ]],
				false
			)
		end,
	})

	use({
		"terryma/vim-expand-region",
		requires = {
			{ "kana/vim-textobj-user" },
			{ "kana/vim-textobj-line" },
			{ "machakann/vim-textobj-functioncall" },
			{ "sgur/vim-textobj-parameter" },
			{ "whatyouhide/vim-textobj-xmlattr", ft = { "html", "xml" } },
		},
		setup = function()
			vim.g.vim_textobj_parameter_mapping = ","
			vim.g.expand_region_text_objects = {
				["iw"] = 0,
				['i"'] = 0,
				['a"'] = 0,
				["i'"] = 0,
				["a'"] = 0,
				["i]"] = 1,
				["a]"] = 1,
				["i)"] = 1,
				["a)"] = 1,
				["i}"] = 1,
				["a}"] = 1,
				-- ['iB'] = 1,
				-- ['aB'] = 1,
				["i,"] = 0,
				["a,"] = 0,
				["if"] = 0,
				["il"] = 0,
				["ip"] = 0,
				["ix"] = 0,
				["ax"] = 0,
			}
		end,
	})
	map("x", "<m-k>", "<Plug>(expand_region_expand)", { remap = true })
	map("x", "<m-j>", "<Plug>(expand_region_shrink)", { remap = true })
	map("n", "<m-k>", "<Plug>(expand_region_expand)", { remap = true })
	map("n", "<m-j>", "<Plug>(expand_region_shrink)", { remap = true })

	use({ "majutsushi/tagbar" })
	use({ "liuchengxu/vista.vim" })

	use({
		"git@github.com:ipod825/vim-bookmark",
		config = function()
			vim.g.bookmark_opencmd = "NewTabdrop"
			vim.api.nvim_exec(
				[[
        function! BookmarkContext()
            return [tagbar#currenttag("%s", "", "f"), getline('.')]
        endfunction
        let g:Bookmark_pos_context_fn = function('BookmarkContext')
        augroup BOOKMARK
            autocmd!
            autocmd Filetype bookmark nmap <buffer> <c-t> <cmd>call bookmark#open('Tabdrop')<cr>
        augroup END
        ]],
				false
			)
		end,
	})
	map("n", "'", "<cmd>BookmarkGo netranger<cr>")
	map("n", "<leader>'", "<cmd>BookmarkGo<cr>")
	map("n", "<leader>m", "<cmd>BookmarkAddPos<cr>")

	use({ "machakann/vim-sandwich" })
	use({
		"justinmk/vim-sneak",
		config = function()
			vim.g["sneak#label"] = 1
			vim.g["sneak#absolute_dir"] = -4
		end,
	})
	map("n", "f", "<Plug>Sneak_s", { remap = true })
	map("n", "F", "<Plug>Sneak_S", { remap = true })

	use({ "machakann/vim-swap" })

	use({
		"eugen0329/vim-esearch",
		branch = "development",
		setup = function()
			vim.g.esearch = {
				adapter = "rg",
				bckend = "nvim",
				out = "win",
				batch_size = 1000,
				default_mappings = 0,
				live_update = 0,
				win_ui_nvim_syntax = 1,
				remember = {
					"case",
					"regex",
					"filetypes",
					"before",
					"after",
					"context",
				},
				win_map = {
					{ "n", "<cr>", '<cmd>call b:esearch.open("NewTabdrop")<cr>' },
					{ "n", "t", '<cmd>call b:esearch.open("NETRTabdrop")<cr>' },
					{
						"n",
						"pp",
						"<cmd>call b:esearch.split_preview_open() | wincmd W<cr>",
					},
					{
						"n",
						"R",
						'<cmd>call b:esearch.reload({"backend": "system"})<cr>',
					},
				},
			}
		end,
		config = function()
			vim.api.nvim_exec(
				[[
        augroup ESEARCH
            autocmd!
            autocmd ColorScheme * highlight! link esearchMatch Cursor
            autocmd Filetype esearch silent! tabmove -1
        augroup END
        ]],
				false
			)
		end,
	})
	map("n", "<leader>f", "<Plug>(operator-esearch-prefill)iw", { remap = true })
	map("x", "<leader>f", "<Plug>(esearch)", { remap = true })
	map("n", "<leader>F", '<cmd>call esearch#init({"prefill":["cword"], "paths": expand("%:p")})<cr>')
	map("x", "<leader>F", 'esearch#prefill({"paths": expand("%:p")})', { expr = true })

	use({ "kkoomen/vim-doge" })
	use({ "will133/vim-dirdiff" })

	use({
		"skywind3000/asyncrun.vim",
		config = function()
			vim.g.asyncrun_exit = "lua utils.asyncrun_callback()"
			vim.g.asyncrun_pathfix = 1
			vim.api.nvim_exec(
				[[
                augroup PACKER
                    autocmd!
                    autocmd User AsyncRunPre lua utils.asyncrun_pre()
                augroup END
            ]],
				false
			)
			vim.g.asyncrun_open = 6
		end,
	})

	use({
		"skywind3000/asynctasks.vim",
		config = function()
			vim.g.asynctasks_term_reuse = 1
			vim.g.asynctasks_confirm = 0
		end,
	})

	use({
		"embear/vim-localvimrc",
		config = function()
			vim.g.localvimrc_ask = 0
		end,
	})

	use({ "andymass/vim-matchup" })
	use({ "AndrewRadev/linediff.vim" })

	use({ "~/projects/nvim-ranger.lua", disable = true })
	use({
		"~/projects/nvim-multisearch.lua",
		disable = true,
		config = function()
			require("multisearch").setup()
		end,
	})
	use({
		"git@github.com:ipod825/vim-netranger",
		disable = false,
		setup = function()
			vim.g.NETRRifleFile = vim.env.HOME .. "/dotfiles/config/nvim/settings/rifle.conf"
			vim.g.NETRIgnore = {
				"__pycache__",
				"*.pyc",
				"*.o",
				"egg-info",
				"tags",
			}
			vim.g.NETRColors = { dir = 39, footer = 35, exe = 35 }
			vim.g.NETRGuiColors = {
				dir = "#00afff",
				footer = "#00af5f",
				exe = "#00af5f",
			}
			vim.g.NETRRifleDisplayError = false
			vim.g.NETRDefaultMapSkip = { "<cr>" }
		end,
		config = function()
			vim.api.nvim_exec(
				[[
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
        ]],
				false
			)
		end,
	})

	if packer_bootstrap then
		vim.cmd("PackerSync")
	end
end)
