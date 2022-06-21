local M = _G.plugins or {}
_G.plugins = M
local map = vim.keymap.set
local unmap = vim.keymap.del
local Plug = require("vplug")
local V = require("Vim")

Plug.begin()

Plug("kyazdani42/nvim-web-devicons")

Plug("terrortylor/nvim-comment", {
	branch = "main",
	config = function()
		require("nvim_comment").setup({
			comment_empty = true,
			create_mapping = false,
		})
		map("n", "<c-/>", "<cmd>CommentToggle<cr>")
		map("v", "<c-/>", ":<c-u>call CommentOperator(visualmode())<cr>")
	end,
})

Plug("nvim-treesitter/nvim-treesitter", {
	run = ":TSUpdate",
	config = function()
		vim.cmd([[
            set foldmethod=expr
            set foldexpr=nvim_treesitter#foldexpr()
            ]])
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
				"java",
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

Plug("lewis6991/spellsitter.nvim", {
	config = function()
		require("spellsitter").setup({ enable = true })
	end,
})

Plug("ray-x/lsp_signature.nvim")
Plug("tridactyl/vim-tridactyl")

Plug("nvim-treesitter/nvim-treesitter-textobjects", {
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

Plug("nvim-treesitter/playground", {
	on_cmd = "TSPlaygroundToggle",
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

-- Plug('romgrk/nvim-treesitter-context')
Plug("haringsrob/nvim_context_vt")
Plug("wellle/context.vim", {
	on_cmd = "ContextPeek",
	setup = function()
		vim.g.context_add_mappings = 0
		vim.g.context_enabled = 0
	end,
	config = function()
		map("n", "<m-i>", "<cmd>ContextPeek<cr>")
	end,
})

Plug("ldelossa/litee.nvim", {
	config = function()
		require("litee.lib").setup()
	end,
})

Plug("ldelossa/litee-filetree.nvim", {
	config = function()
		require("litee.filetree").setup({})
	end,
})

Plug("ldelossa/gh.nvim", {
	config = function()
		require("litee.gh").setup()
	end,
})

Plug("tpope/vim-abolish")

Plug("gbprod/yanky.nvim", {
	config = function()
		require("yanky").setup({})
		vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", {})
		vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", {})
		vim.keymap.set("x", "p", "<Plug>(YankyPutAfter)", {})
		vim.keymap.set("x", "P", "<Plug>(YankyPutBefore)", {})
		vim.keymap.set("n", "gp", "<Plug>(YankyGPutAfter)", {})
		vim.keymap.set("n", "gP", "<Plug>(YankyGPutBefore)", {})
		vim.keymap.set("x", "gp", "<Plug>(YankyGPutAfter)", {})
		vim.keymap.set("x", "gP", "<Plug>(YankyGPutBefore)", {})
		require("telescope._extensions").load("yank_history")
	end,
})

Plug("nvim-telescope/telescope-fzf-native.nvim", {
	branch = "main",
	run = "make",
	config = function()
		require("telescope._extensions.fzf").setup({
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		}, {})
		require("telescope._extensions").load("fzf")
	end,
})
Plug("nvim-telescope/telescope-file-browser.nvim", {
	config = function()
		local fb_actions = require("telescope").extensions.file_browser.actions
		require("telescope._extensions.file_browser").setup({
			initial_mode = "normal",
			layout_strategy = "horizontal",
			mappings = {
				["n"] = {
					o = fb_actions.create,
					r = fb_actions.rename,
					yp = fb_actions.copy,
					dp = fb_actions.move,
					D = fb_actions.remove,
					zh = fb_actions.toggle_hidden,
					l = fb_actions.goto_cwd,
					h = fb_actions.goto_parent_dir,
					L = fb_actions.change_cwd,
				},
			},
		})
		require("telescope._extensions").load("file_browser")
	end,
})
Plug("tami5/sqlite.lua")
Plug("nvim-telescope/telescope-frecency.nvim", {
	disable = true,
	config = function()
		require("telescope._extensions.frecency").setup({
			show_scores = false,
			show_unindexed = true,
			ignore_patterns = { "*.git/*", "*/tmp/*" },
			workspaces = {
				["c"] = ("%s/dotfiles"):format(vim.env.HOME),
				["p"] = ("%s/.local/share/nvim/site/pluggins"):format(vim.env.HOME),
			},
		})
		require("telescope._extensions").load("frecency")

		-- map("n", "<leader>e", function()
		-- 	require("telescope").extensions.frecency.frecency({
		-- 		default_text = ":c:",
		-- 	})
		-- end)

		-- map("n", "<c-m-o>", function()
		-- 	require("telescope").extensions.frecency.frecency()
		-- end)
	end,
})
Plug("nvim-telescope/telescope-cheat.nvim", {
	config = function()
		require("telescope._extensions").load("cheat")
	end,
})
Plug("nvim-telescope/telescope.nvim", {
	config = function()
		local actions = require("telescope.actions")
		local select_to_edit_map = {
			default = "edit",
			horizontal = "new",
			vertical = "vnew",
			tab = "Tabdrop",
		}
		require("telescope.actions.state").select_key_to_edit_key = function(type)
			return select_to_edit_map[type]
		end
		local full = 9999
		require("telescope").setup({
			defaults = {
				scroll_strategy = "limit",
				winblend = 10,
				sorting_strategy = "ascending",
				multi_icon = "* ",
				path_display = { "truncate" },
				layout_strategy = "vertical",
				borderchars = {
					prompt = { "─", " ", " ", " ", " ", " ", " ", " " },
					results = { "─", " ", " ", " ", " ", " ", " ", " " },
					preview = { "─", " ", " ", " ", " ", " ", " ", " " },
				},
				layout_config = {
					horizontal = {
						height = full,
						width = full,
						preview_width = 0.7,
						prompt_position = "top",
					},
					vertical = {
						mirror = true,
						height = full,
						width = full,
						prompt_position = "top",
						preview_height = 0.6,
						preview_cutoff = 0,
					},
				},
				mappings = {
					i = {
						["<cr>"] = actions.select_tab,
						["<c-e>"] = actions.select_default,
						["<c-j>"] = actions.move_selection_next,
						["<c-k>"] = actions.move_selection_previous,
						["<c-b>"] = actions.results_scrolling_up,
						["<c-f>"] = actions.results_scrolling_down,
						["<c-n>"] = actions.cycle_history_next,
						["<c-p>"] = actions.cycle_history_prev,
						["<c-u>"] = function()
							vim.cmd([[normal! "_dd]])
						end,
					},
					n = {
						["<cr>"] = actions.select_tab,
						["<c-e>"] = actions.select_default,
						["<C-c>"] = actions.close,
						["<c-b>"] = actions.results_scrolling_up,
						["<c-f>"] = actions.results_scrolling_down,
						["<c-n>"] = actions.cycle_history_next,
						["<c-p>"] = actions.cycle_history_prev,
					},
				},
			},
		})

		vim.api.nvim_set_hl(0, "TelescopeSelection", { default = true, link = "Pmenu" })
		vim.api.nvim_set_hl(0, "TelescopeBorder", { default = true, link = "Label" })

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local builtin = require("telescope.builtin")

		vim.cmd("cnoreabbrev help lua require'telescope.builtin'.help_tags({default_text=''})<left><left><left>")
		map("n", "<c-o>", function()
			builtin.fd({ cwd = vim.fn.FindRootDirectory() })
		end)

		map("n", "/", function()
			builtin.current_buffer_fuzzy_find({
				previewer = false,
			})
		end)

		map("n", "zs", function()
			builtin.spell_suggest()
		end)

		map("n", "<leader>e", function()
			local opts = {}
			pickers.new(opts, {
				finder = finders.new_table({
					results = vim.fn.systemlist("$HOME/dotfiles/misc/watchfiles.sh nvim"),
				}),
				previewer = conf.file_previewer(opts),
				sorter = conf.generic_sorter(opts),
			}):find()
		end)
		map("n", "<c-m-o>", function()
			local opts = {}
			pickers.new(opts, {
				finder = finders.new_table({
					results = vim.tbl_filter(function(e)
						return vim.fn.filereadable(e) ~= 0
					end, require("oldfiles").oldfiles()),
				}),
				previewer = conf.file_previewer(opts),
				sorter = conf.generic_sorter(opts),
			}):find()
		end)
	end,
})

Plug("junegunn/fzf", { run = "call fzf#install()" })

Plug("j-hui/fidget.nvim", {
	disable = true,
	branch = "main",
	config = function()
		require("fidget").setup()
	end,
})

Plug("airblade/vim-rooter", {
	setup = function()
		vim.g.rooter_manual_only = 1
	end,
})

Plug("glacambre/firenvim", {
	run = 'lua vim.fn["firenvim#install"](0)',
	setup = function()
		vim.g.firenvim_config = {
			localSettings = {
				[".*"] = {
					takeover = "never",
				},
			},
		}
	end,
	config = function()
		vim.g.firenvim_config = {
			localSettings = {
				[".*"] = {
					takeover = "never",
				},
			},
		}
		vim.api.nvim_create_autocmd("UIEnter", {
			group = vim.api.nvim_create_augroup("FIRE_NVIM", {}),
			callback = function()
				if not vim.g.started_by_firenvim then
					return
				end
				vim.o.laststatus = 0
				map("n", "q", "<cmd>x<cr>")
				-- require("colorscheme").load({ bg = "#f7f7f7", bg_highlight = "#e0e0e0" })

				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = "*colab.corp.google.com_*",
					callback = function()
						vim.bo.filetype = "python"
					end,
				})
			end,
		})
	end,
})

Plug("kevinhwang91/promise-async")
Plug("kevinhwang91/nvim-ufo", {
	disable = true,
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		require("ufo").setup()
	end,
})

Plug("wsdjeg/vim-fetch")
Plug("git@github.com:ipod825/vim-tabdrop")

Plug("jreybert/vimagit")

-- Plug('nvim-lua/plenary.nvim')
Plug("git@github.com:ipod825/plenary.nvim", {
	config = function()
		vim.api.nvim_create_autocmd("Filetype", {
			group = vim.api.nvim_create_augroup("PLENARY", {}),
			pattern = "lua",
			callback = function()
				map("n", "<F5>", function()
					require("plenary.test_harness").test_directory(vim.fn.expand("%:p"))
				end, { desc = "plenary test file" })
			end,
		})
	end,
})

Plug("hoob3rt/lualine.nvim", {
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
		local lualine_netranger = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = { { "filename", file_status = false } },
				lualine_c = { { "branch", condition = enable_fn } },
			},
			filetypes = { "netranger" },
		}
		local lualine_gina = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = { { "filename", file_status = false } },
				lualine_c = {
					{
						function()
							return " " .. vim.fn.trim(vim.fn.system("git branch --show-current"))
						end,
						condition = enable_fn,
					},
				},
			},
			filetypes = { "gina-status" },
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
			extensions = { lualine_netranger, "quickfix" },
		})
	end,
})

Plug("git@github.com:ipod825/msearch.vim", {
	config = function()
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
	end,
})

Plug("fatih/vim-go", { ft = "go" })

Plug("voldikss/vim-translator", { cmd = "TranslateW" })

Plug("chaoren/vim-wordmotion", {
	setup = function()
		vim.g.wordmotion_nomap = 1
		map("n", "w", "<Plug>WordMotion_w", { remap = true })
		map("x", "w", "<Plug>WordMotion_e", { remap = true })
		map("o", "w", "<Plug>WordMotion_e", { remap = true })
		map("n", "e", "<Plug>WordMotion_e", { remap = true })
		map("x", "e", "<Plug>WordMotion_e", { remap = true })
		map("n", "b", "<Plug>WordMotion_b", { remap = true })
		map("x", "b", "<Plug>WordMotion_b", { remap = true })
		map("x", "iv", "<Plug>WordMotion_iw", { remap = true })
		map("o", "iv", "<Plug>WordMotion_iw", { remap = true })
	end,
})

Plug("windwp/nvim-autopairs", {
	config = function()
		require("nvim-autopairs").setup({ fast_wrap = {} })
	end,
})

Plug("tpope/vim-endwise")

Plug("mg979/vim-visual-multi", {
	branch = "test",
	utils = {
		VSelectAllMark = function()
			local range = V.visual_range()
			vim.cmd(
				string.format("%d,%d VMSearch %s", range.line_beg, range.line_end, vim.fn["msearch#joint_pattern"]())
			)
		end,
	},
	setup = function()
		vim.g.VM_default_mappings = 0
		map("n", "<leader>r", function()
			vim.cmd("VMSearch " .. vim.fn["msearch#joint_pattern"]())
			V.feed_plug_keys("(VM-Select-All)")
			V.feed_plug_keys("(VM-Goto-Prev)")
		end, { desc = "select all marks" })
		map("x", "<leader>r", ":<c-u>lua plug.utils.VSelectAllMark()<cr>")
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
			["Add Cursor At Pos"] = "<c-i>",
			["Visual Cursors"] = "<c-i>",
			["Visual Reduce"] = "<leader>r",
			["Visiual Subtract"] = "<leader>s",
			["Increase"] = "+",
			["Decrease"] = "-",
			["Exit"] = "<Esc>",
			["Transpose"] = "<leader>t",
			["Case conversion"] = "<leader>c",
			["Go-to-regex motion"] = "\\g",
			["Toggle Single Region"] = "\\<cr>",
			-- Not used in my flow
			["Visual Regex"] = "<leader>/",
		}
	end,
	config = function()
		vim.g.VM_reselect_first = 1
		vim.g.VM_notify_previously_selected = 1
		vim.g.VM_theme = "iceblue"

		vim.g.VM_custom_motions = { ["<m-h>"] = "^", ["<m-l>"] = "$" }
		vim.g.VM_custom_noremaps = {
			["])"] = "])",
			["]]"] = "]]",
			["]}"] = "])",
			["w"] = "e",
		}
		local VISUAL_MULTI = vim.api.nvim_create_augroup("VISUAL_MULTI", {})
		vim.api.nvim_create_autocmd("User", {
			group = VISUAL_MULTI,
			pattern = "visual_multi_start",
			callback = function()
				vim.fn.setreg('"', "")
				map("i", "jk", "<esc>", { buffer = true })
				map("i", "<c-h>", "<left>", { buffer = true, remap = true })
				map("i", "<c-l>", "<right>", { buffer = true, remap = true })
				map("i", "<c-j>", "<down>", { buffer = true, remap = true })
				map("i", "<c-k>", "<up>", { buffer = true, remap = true })
				map("i", "<m-h>", "<esc><m-h>i", { buffer = true, remap = true })
				map("i", "<m-l>", "<esc><m-l>i", { buffer = true, remap = true })
				map("n", "J", "<down>", { buffer = true })
				map("n", "K", "<up>", { buffer = true })
				map("n", "H", "<Left>", { buffer = true })
				map("n", "L", "<Right>", { buffer = true })
				map("n", "<c-c>", "<Esc>", { buffer = true })
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = VISUAL_MULTI,
			pattern = "visual_multi_exit",
			callback = function()
				unmap("i", "jk", { buffer = true })
				unmap("i", "<c-h>", { buffer = true })
				unmap("i", "<c-l>", { buffer = true })
				unmap("i", "<c-j>", { buffer = true })
				unmap("i", "<c-k>", { buffer = true })
				unmap("i", "<m-h>", { buffer = true })
				unmap("i", "<m-l>", { buffer = true })
				unmap("n", "J", { buffer = true })
				unmap("n", "K", { buffer = true })
				unmap("n", "H", { buffer = true })
				unmap("n", "L", { buffer = true })
				unmap("n", "<c-c>", { buffer = true })
			end,
		})
	end,
})

Plug("lukas-reineke/indent-blankline.nvim", {
	config = function()
		vim.g.indent_blankline_use_treesitter = true
		vim.g.indentLine_fileTypeExclude = { "tex", "markdown", "txt", "startify", "packer" }
	end,
})

Plug("hrsh7th/cmp-nvim-lua")
Plug("hrsh7th/cmp-nvim-lsp-signature-help", { branch = "main" })
Plug("hrsh7th/cmp-buffer", { branch = "main" })
Plug("hrsh7th/cmp-nvim-lsp", { branch = "main" })
Plug("hrsh7th/cmp-vsnip", { branch = "main" })
Plug("hrsh7th/cmp-path", { branch = "main" })
Plug("hrsh7th/cmp-nvim-lua", { branch = "main" })
Plug("f3fora/cmp-spell")
Plug("hrsh7th/cmp-cmdline", { branch = "main" })
Plug("hrsh7th/nvim-cmp", {
	branch = "main",
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
				["<cr>"] = cmp.mapping.confirm({ select = true }),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help" },
				{ name = "nvim_lua" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "vsnip" },
				{ name = "spell" },
			}),
		})
	end,
})

Plug("norcalli/nvim-colorizer.lua", {
	config = function()
		require("colorizer").setup()
	end,
})

Plug("lervag/vimtex", {
	ft = "tex",
	config = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_fold_enabled = 1
		vim.g.vimtex_log_ignore = { "25" }
		vim.g.vimtex_view_general_viewer = "zathura"
		vim.g.tex_conceal = "abdgm"
	end,
})

Plug("hrsh7th/vim-vsnip-integ")
Plug("hrsh7th/vim-vsnip", {
	setup = function()
		vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets/vsnip"
	end,
	config = function()
		map(
			"i",
			"<tab>",
			'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<tab>"',
			{ expr = true, remap = true }
		)
		map("i", "<s-tab>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true, remap = true })
		map("s", "<tab>", 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<tab>"', { expr = true, remap = true })
		map("s", "<s-tab>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true, remap = true })
	end,
})

Plug("rhysd/vim-grammarous", { on_cmd = "GrammarousCheck" })

Plug("mfussenegger/nvim-dap")
Plug("puremourning/vimspector")

Plug("git@github.com:ipod825/julia-unicode.vim", { ft = "julia" })

Plug("junegunn/vim-easy-align", {
	config = function()
		map("n", "ga", "<Plug>(EasyAlign)", { remap = true })
		map("x", "ga", "<Plug>(EasyAlign)", { remap = true })
	end,
})

Plug("farmergreg/vim-lastplace")

Plug("git@github.com:ipod825/war.vim", {
	config = function()
		local WAR = vim.api.nvim_create_augroup("WAR", {})
		vim.api.nvim_create_autocmd("Filetype", {
			group = WAR,
			pattern = "esearch",
			callback = function()
				vim.fn["war#fire"](0.8, -1, 0.2, -1)
			end,
		})
		vim.api.nvim_create_autocmd("Filetype", {
			group = WAR,
			pattern = "bookmark",
			callback = function()
				vim.fn["war#fire"](-1, 1, -1, 0.2)
				vim.fn["war#enter"](-1)
			end,
		})
	end,
})

Plug("vim-test/vim-test", { disable = true })

Plug("hkupty/iron.nvim", {
	config = function()
		local iron = require("iron.core")
		iron.setup({
			config = {
				-- If iron should expose `<plug>(...)` mappings for the plugins
				should_map_plug = false,
				scratch_repl = true,
				repl_definition = {
					sh = {
						command = { "zsh" },
					},
					python = {
						command = { "ipython" },
					},
				},
				repl_open_cmd = "vsplit",
			},
			-- Iron doesn't set keymaps by default anymore. Set them here
			-- or use `should_map_plug = true` and map from you vim files
			keymaps = {
				visual_send = "E",
				send_line = "E",
				exit = "<space>sq",
				clear = "<space>cl",
			},
		})
	end,
})

Plug("kosayoda/nvim-lightbulb", {
	config = function()
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = vim.api.nvim_create_augroup("LIGHBULB", {}),
			callback = function()
				require("nvim-lightbulb").update_lightbulb()
			end,
		})
	end,
})

Plug("kevinhwang91/nvim-bqf", {
	branch = "main",
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

Plug("lukas-reineke/lsp-format.nvim", {
	config = function()
		require("lsp-format").setup({
			lua = {
				exclude = { "sumneko_lua" },
			},
		})
	end,
})
Plug("williamboman/nvim-lsp-installer", {
	branch = "main",
	config = function()
		require("nvim-lsp-installer").setup({})
	end,
})
Plug("neovim/nvim-lspconfig")

Plug("mhartington/formatter.nvim", {
	config = function()
		local isort = function()
			return { exe = "isort", args = { "-", "--quiet" }, stdin = true }
		end
		local lua_format = function()
			return {
				exe = "stylua",
				args = {
					"--search-parent-directories",
					"-",
				},
				stdin = true,
			}
		end
		require("formatter").setup({
			logging = false,
			filetype = {
				python = { isort },
				lua = { lua_format },
			},
		})
		local enable_formatter = true
		vim.api.nvim_create_user_command("ToggleFormatter", function()
			enable_formatter = not enable_formatter
		end, {})
		vim.api.nvim_create_autocmd("BufwritePost", {
			group = vim.api.nvim_create_augroup("FORMATTER", {}),
			callback = function()
				if enable_formatter then
					vim.cmd("FormatWrite")
				end
			end,
		})
	end,
})

Plug("kana/vim-textobj-user")
Plug("kana/vim-textobj-line")
Plug("machakann/vim-textobj-functioncall")
Plug("sgur/vim-textobj-parameter")
Plug("whatyouhide/vim-textobj-xmlattr", { ft = { "html", "xml" } })
Plug("git@github.com:ipod825/vim-expand-region", {
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
			["i,"] = 0,
			["a,"] = 0,
			["if"] = 0,
			["il"] = 0,
			["ip"] = 0,
			["ix"] = 0,
			["ax"] = 0,
		}
	end,
	config = function()
		local EXPANDREGION = vim.api.nvim_create_augroup("EXPANDREGION", {})
		vim.api.nvim_create_autocmd("User", {
			group = EXPANDREGION,
			pattern = "ExpandRegionStart",
			callback = function()
				unmap("n", "8")
				unmap("x", "8")
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = EXPANDREGION,
			pattern = "ExpandRegionStop",
			callback = function()
				map("n", "8", "<Plug>MSToggleAddCword", { remap = true })
				map("x", "8", "<Plug>MSToggleAddVisual", { remap = true })
			end,
		})
		map("x", "<m-k>", "<Plug>(expand_region_expand)", { remap = true })
		map("x", "<m-j>", "<Plug>(expand_region_shrink)", { remap = true })
		map("n", "<m-k>", "<Plug>(expand_region_expand)", { remap = true })
		map("n", "<m-j>", "<Plug>(expand_region_shrink)", { remap = true })
	end,
})

Plug("majutsushi/tagbar")

Plug("git@github.com:ipod825/oldfiles.nvim", {
	branch = "main",
	config = function()
		require("oldfiles").setup()
	end,
})

Plug("git@github.com:ipod825/vim-bookmark", {
	config = function()
		vim.g.bookmark_opencmd = "NewTabdrop"
		vim.g.Bookmark_pos_context_fn = function()
			return {
				vim.fn["tagbar#currenttag"]("%s", "", "f"),
				vim.fn.getline("."),
			}
		end

		local BOOKMARK = vim.api.nvim_create_augroup("BOOKMARK", {})
		vim.api.nvim_create_autocmd("Filetype", {
			group = BOOKMARK,
			pattern = { "bookmark" },
			callback = function()
				map("n", "<c-t>", function()
					vim.fn["bookmark#open"]("Tabdrop")
				end, { buffer = 0 })
			end,
		})
		map("n", "'", "<cmd>BookmarkGo directory<cr>")
		map("n", "m", "<cmd>BookmarkAddPos directory<cr>")
		map("n", "<leader>'", "<cmd>BookmarkGo<cr>")
		map("n", "<leader>m", "<cmd>BookmarkAddPos<cr>")
	end,
})

Plug("machakann/vim-sandwich")
Plug("justinmk/vim-sneak", {
	config = function()
		vim.g["sneak#label"] = 1
		vim.g["sneak#absolute_dir"] = -4
		map("n", "f", "<Plug>Sneak_s", { remap = true })
		map("n", "F", "<Plug>Sneak_S", { remap = true })
	end,
})

Plug("machakann/vim-swap")

Plug("eugen0329/vim-esearch", {
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
			root_markers = { ".git", ".hg", ".svn", ".bzr", "_darcs", "OWNERS", ".root" },
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
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("ESEARCH", {}),
			command = "highlight! link esearchMatch Cursor",
		})
		map("n", "<leader>f", "<Plug>(operator-esearch-prefill)iw", { remap = true })
		map("x", "<leader>f", "<Plug>(esearch)", { remap = true })
		map("n", "<leader>F", '<cmd>call esearch#init({"prefill":["cword"], "paths": expand("%:p")})<cr>')
		map("x", "<leader>F", 'esearch#prefill({"paths": expand("%:p")})', { expr = true })
	end,
})

Plug("kkoomen/vim-doge", { disable = true })
Plug("will133/vim-dirdiff", { on_cmd = "DirDiff" })

Plug("mrjones2014/smart-splits.nvim")

Plug("skywind3000/asyncrun.vim", {
	utils = {
		AsyncrunPre = function()
			vim.cmd("wincmd o")
			vim.g.asyncrun_win = vim.api.nvim_get_current_win()
		end,
		AsyncrunCallback = function()
			vim.api.nvim_set_current_win(vim.g.asyncrun_win)
			if vim.g.asyncrun_code == 0 then
				vim.cmd("cclose")
			else
				vim.fn.setqflist(
					vim.tbl_filter(function(e)
						return e.valid ~= 0
					end, vim.fn.getqflist()),
					"r"
				)
				vim.cmd("botright copen")
			end
			vim.fn.system([[zenity --info --text Done --display=$DISPLAY]])
			vim.fn.system([[notify-send -u critical -t 5000 'Job Finished' `printf '~%.0s' {1..100}`]])
		end,
	},
	config = function()
		vim.g.asyncrun_pathfix = 1
		vim.g.asyncrun_open = 6
		vim.g.asyncrun_exit = "lua plug.utils.AsyncrunCallback()"
		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("ASYNCRUN", {}),
			pattern = "AsyncRunPre",
			callback = function()
				vim.cmd("wincmd o")
				vim.g.asyncrun_win = vim.api.nvim_get_current_win()
			end,
		})
	end,
})

Plug("skywind3000/asynctasks.vim", {
	config = function()
		vim.g.asynctasks_term_reuse = 1
		vim.g.asynctasks_confirm = 0
	end,
})

-- Plug("tanvirtin/vgit.nvim", {
-- 	diable = true,
-- 	branch = "main",
-- 	config = function()
-- 		require("vgit").setup({ settings = { live_gutter = { enabled = false } } })
-- 	end,
-- })
-- Plug("TimUntersberger/neogit")
Plug("lambdalisue/gina.vim", {
	config = function()
		vim.g["gina#action#index#discard_directories"] = 1
		vim.cmd(string.format("source %s", vim.fn.stdpath("config") .. "/ginasetup.vim"))
	end,
})

Plug("whiteinge/diffconflicts")

Plug("git@github.com:ipod825/libp.nvim", { branch = "main" })
Plug("git@github.com:ipod825/igit.nvim", {
	branch = "main",
	config = function()
		vim.cmd("cnoreabbrev G IGit status")
		vim.cmd("cnoreabbrev gbr IGit branch")
		vim.cmd("cnoreabbrev glg IGit log")
		vim.cmd("cnoreabbrev gps IGit push")
		vim.cmd("cnoreabbrev gpl IGit pull")
		vim.cmd("cnoreabbrev grc IGit rebase --continue")
		vim.cmd("cnoreabbrev gra IGit rebase --abort")
		vim.cmd(
			[[cnoreabbrev glc exec 'IGit log --branches --graph --follow --author="Shih-Ming Wang" -- '.expand("%:p")]]
		)
		require("igit").setup({
			branch = {
				confirm_rebase = false,
			},
			log = { confirm_rebase = false },
			status = {},
		})
	end,
})

Plug("andymass/vim-matchup")
Plug("AndrewRadev/linediff.vim", { on_cmd = { "LineDiffAdd" } })

Plug("chrisbra/Colorizer")
Plug("powerman/vim-plugin-AnsiEsc")

Plug("git@github.com:ipod825/vim-netranger", {
	setup = function()
		vim.g.NETRRifleFile = vim.env.HOME .. "/dotfiles/config/nvim/settings/rifle.conf"
		vim.g.NETRIgnore = { "__pycache__", "*.pyc", "*.o", "egg-info", "tags" }
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
              BookmarkAdd directory
          endfunction
      
          function! NETRBookMarkGo()
              BookmarkGo directory
          endfunction
      
          function! NETRInit()
              call netranger#api#mapvimfn('yp', "DuplicateNode")
              call netranger#api#mapvimfn('m', "NETRBookMark")
              call netranger#api#mapvimfn("\'", "NETRBookMarkGo")
          endfunction
      
          let g:NETRCustomNopreview={->winnr()==2 && winnr('$')==2}
      
          autocmd! USER NETRInit call NETRInit()
          ]])
	end,
})

Plug.ends()

return M
