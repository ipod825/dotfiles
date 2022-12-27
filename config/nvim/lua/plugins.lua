local M = {}
local map = vim.keymap.set
local unmap = vim.keymap.del
local Plug = require("vplug")
local utils = require("utils")

local root_markers = { ".git", ".hg", ".svn", ".bzr", "_darcs", ".root" }

Plug.begin()

Plug("kyazdani42/nvim-web-devicons")
Plug("tridactyl/vim-tridactyl")
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

Plug("wsdjeg/vim-fetch")
Plug("farmergreg/vim-lastplace")
Plug("norcalli/nvim-colorizer.lua", {
	setup = function()
		vim.o.termguicolors = true
	end,
	config = function()
		require("colorizer").setup()
	end,
})
Plug("terrortylor/nvim-comment", {
	config = function()
		require("nvim_comment").setup({
			comment_empty = true,
			create_mapping = false,
		})
		map("n", "<c-/>", "<cmd>CommentToggle<cr>")
		map("v", "<c-/>", ":<c-u>call CommentOperator(visualmode())<cr>")
		map("n", "<c-_>", "<cmd>CommentToggle<cr>")
		map("v", "<c-_>", ":<c-u>call CommentOperator(visualmode())<cr>")
	end,
})

Plug("kevinhwang91/promise-async")
Plug("kevinhwang91/nvim-ufo", {
	config = function()
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = -1
		vim.o.foldenable = true
		local handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = ("  %d "):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end

		require("ufo").setup({
			fold_virt_text_handler = handler,
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
			preview = {
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
				},
			},
		})
		vim.keymap.set("n", "<leader>o", require("ufo").openAllFolds)
		vim.keymap.set("n", "<leader>c", require("ufo").closeAllFolds)
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end)
	end,
})
Plug("git@github.com:ipod825/vim-tabdrop")
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

Plug("nvim-lua/plenary.nvim", {
	-- Plug("git@github.com:ipod825/plenary.nvim", {
	config = function()
		vim.api.nvim_create_autocmd("Filetype", {
			group = vim.api.nvim_create_augroup("PLENARY", {}),
			pattern = "lua",
			callback = function()
				map("n", "<F6>", function()
					require("plenary.test_harness").test_directory(vim.fn.expand("%:p"))
				end, { desc = "plenary test file" })
			end,
		})
	end,
})

Plug("nvim-treesitter/nvim-treesitter", {
	run = ":TSUpdate",
	config = function()
		local color = require("colorscheme").color
		local languages = {
			"bash",
			"cpp",
			"java",
			"lua",
			"python",
			"kotlin",
			"org",
		}
		local languages_spell_set = vim.list_extend({ "gitcommit", "proto", "sdl", "hgcommit" }, languages)
		vim.tbl_add_reverse_lookup(languages_spell_set)

		require("colorscheme").add_plug_hl({
			TSFunction = { fg = color.cyan },
			TSMethod = { fg = color.cyan },
			TSKeywordFunction = { fg = color.red },
			TSProperty = { fg = color.yellow },
			TSType = { fg = color.teal },
			TSVariable = { fg = color.blue },
			TSPunctBracket = { fg = color.bracket },
		})
		require("nvim-treesitter.configs").setup({
			ensure_installed = languages,
			highlight = { enable = true, additional_vim_regex_highlighting = { "org" } },
			incremental_selection = { enable = false },
			indent = { enable = false },
			endwise = {
				enable = true,
			},
		})
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("TREESITTER_SPELL", {}),
			callback = function()
				vim.defer_fn(function()
					vim.wo.spell = languages_spell_set[vim.bo.filetype] ~= nil
				end, 0)
			end,
		})
	end,
})

Plug("p00f/nvim-ts-rainbow", {
	config = function()
		require("nvim-treesitter.configs").setup({
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			require("colorscheme").add_plug_hl({
				rainbowcol1 = { fg = "#e5c07b", bold = true },
				rainbowcol2 = { fg = "#8CCBEA", bold = true },
				rainbowcol3 = { fg = "#A4E57E", bold = true },
				rainbowcol4 = { fg = "#FF7272", bold = true },
				rainbowcol5 = { fg = "#FFB3FF", bold = true },
				rainbowcol6 = { fg = "#9999FF", bold = true },
			}),
		})
	end,
})

Plug("RRethy/nvim-treesitter-endwise")

Plug("windwp/nvim-ts-autotag", {
	config = function()
		require("nvim-ts-autotag").setup()
	end,
})

Plug("nvim-treesitter/nvim-treesitter-textobjects", {
	disable = true,
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
				updatetime = 25,
				persist_queries = false,
			},
		})
	end,
})

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

Plug("tpope/vim-abolish")

Plug("tami5/sqlite.lua")
Plug("nvim-telescope/telescope-cheat.nvim", {
	config = function()
		require("telescope._extensions").load("cheat")
	end,
})

Plug("nvim-telescope/telescope.nvim", {
	config = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local action_set = require("telescope.actions.set")
		local select_to_edit_map = {
			default = "edit",
			horizontal = "new",
			vertical = "vnew",
			tab = "tabedit",
			force_edit = "edit",
		}
		require("telescope.actions.state").select_key_to_edit_key = function(type)
			local entry = action_state.get_selected_entry()
			local filepath = entry[1]
			local cwd = entry.cwd or ""
			if
				(
					vim.fn.filereadable(filepath) ~= 0
					or vim.fn.filereadable(require("libp.utils.pathfn").join(cwd, filepath)) ~= 0
				) and type ~= "force_edit"
			then
				return "Tabdrop"
			else
				return select_to_edit_map[type]
			end
		end
		local myactions = require("telescope.actions.mt").transform_mod({
			select_force_edit = {
				pre = function(prompt_bufnr)
					action_state
						.get_current_history()
						:append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
				end,
				action = function(prompt_bufnr)
					return action_set.select(prompt_bufnr, "force_edit")
				end,
			},
		})
		-- Why do we even need this?
		vim.api.nvim_create_autocmd("Filetype", {
			group = vim.api.nvim_create_augroup("TELESCOPE", {}),
			pattern = "TelescopePrompt",
			callback = function()
				vim.keymap.set("n", "p", function()
					local text = vim.fn.getreg('"'):gsub("\n$", "")
					vim.fn.feedkeys("i" .. text, "n")
				end, { buffer = 0 })
			end,
		})

		local full = 9999
		require("telescope").setup({
			defaults = {
				scroll_strategy = "limit",
				winblend = 10,
				sorting_strategy = "ascending",
				multi_icon = "* ",
				path_display = function(_, path)
					path = path:gsub(vim.env.HOME, "~")
					for _, env in pairs(require("profile").envs) do
						if env.telescope_path_display then
							path = env.telescope_path_display(path)
						end
					end
					return path
				end,
				layout_strategy = "vertical",
				-- file_ignore_patterns = { "doc.*html$" },
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
						["<cr>"] = actions.select_default,
						["<c-e>"] = myactions.select_force_edit,
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
						["<cr>"] = actions.select_default,
						["<c-e>"] = myactions.select_force_edit,
						["<C-c>"] = actions.close,
						["<c-b>"] = actions.results_scrolling_up,
						["<c-f>"] = actions.results_scrolling_down,
						["<c-n>"] = actions.cycle_history_next,
						["<c-p>"] = actions.cycle_history_prev,
					},
				},
			},
		})

		require("colorscheme").add_plug_hl({
			TelescopeSelection = { default = true, link = "Pmenu" },
			TelescopeBorder = { default = true, link = "Label" },
		})

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local builtin = require("telescope.builtin")

		utils.cmdabbrev("help", "lua require'telescope.builtin'.help_tags({default_text=''})<left><left><left>")

		map("n", "<c-m-o>", function()
			builtin.fd({ cwd = require("libp.utils.pathfn").find_directory(root_markers) })
		end)

		map("n", "/", function()
			builtin.current_buffer_fuzzy_find({
				previewer = false,
			})
		end)

		map("n", "z=", function()
			builtin.spell_suggest()
		end)

		map("n", "<leader>b", builtin.buffers)

		local cached_config_files
		map("n", "<leader>e", function()
			local opts = {}
			cached_config_files = cached_config_files
				or vim.tbl_filter(
					function(e)
						return vim.fn.isdirectory(e) == 0
					end,
					vim.split(
						vim.fn.glob("$HOME/dotfiles/**/.[^.]*") .. "\n" .. vim.fn.glob("$HOME/dotfiles/**/*"),
						"\n"
					)
				)
			pickers
				.new(opts, {
					finder = finders.new_table({
						results = cached_config_files,
					}),
					previewer = conf.file_previewer(opts),
					sorter = conf.file_sorter(opts),
					entry_maker = require("telescope.make_entry").gen_from_file(opts),
				})
				:find()
		end)
	end,
})

Plug("LukasPietzschmann/telescope-tabs", {
	config = function()
		require("telescope-tabs").setup({})
	end,
})

Plug("jubnzv/virtual-types.nvim")

Plug("norcalli/nvim-terminal.lua", {
	config = function()
		require("terminal").setup()
	end,
})

Plug("vim-scripts/AnsiEsc.vim")

Plug("gbprod/yanky.nvim", {
	config = function()
		require("yanky").setup({
			highlight = {
				on_put = false,
				on_yank = false,
			},
		})
		local function visual_paste()
			local ori_mode = vim.fn.mode()
			vim.cmd('normal! "_d')
			if ori_mode ~= "V" then
				vim.fn.setreg('"', vim.trim(vim.fn.getreg('"')))
			end
			vim.cmd("normal! P")
		end

		vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)")
		vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set("x", "p", function()
			visual_paste()
		end)
		require("telescope._extensions").load("yank_history")
	end,
})

Plug("nvim-telescope/telescope-fzf-native.nvim", {
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

Plug("junegunn/fzf", { run = "call fzf#install()" })

Plug("jreybert/vimagit")

Plug("hoob3rt/lualine.nvim", {
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename" },
				lualine_c = {
					{ "branch" },
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
			extensions = { "quickfix" },
		})
	end,
})

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
		require("nvim-autopairs").setup({
			enable_moveright = false,
			ignored_next_char = "[,]",
			fast_wrap = {
				map = "<m-e>",
				end_key = "l",
				keys = "hjkgfdsaqwertyuiopzxcvbnm",
				highlight = "Search",
				highlight_grey = "Normal",
			},
		})
	end,
})

Plug("mg979/vim-visual-multi", {
	branch = "test",
	setup = function()
		vim.g.VM_default_mappings = 0
		map("n", "<leader>r", function()
			vim.cmd("VMSearch " .. vim.fn["msearch#joint_pattern"]())
			utils.feed_plug_keys("(VM-Select-All)")
			utils.feed_plug_keys("(VM-Goto-Prev)")
		end, { desc = "select all marks" })
		map("x", "<leader>r", function()
			local vimfn = require("libp.utils.vimfn")
			local beg, ends = vimfn.visual_rows()
			vimfn.ensure_exit_visual_mode()
			vim.cmd(string.format("%d,%d VMSearch %s", beg, ends, vim.fn["msearch#joint_pattern"]()))
		end)
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
			-- ["]]"] = "]]",
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
		require("colorscheme").add_plug_hl({
			"IndentBlanklineChar",
			"IndentBlanklineSpaceChar",
			"IndentBlanklineSpaceCharBlankline",
			"IndentBlanklineContextChar",
			"IndentBlanklineContextStart",
		})
	end,
})

Plug("onsails/lspkind.nvim")
Plug("folke/trouble.nvim", {
	config = function()
		require("trouble").setup({
			require("trouble").setup({
				position = "bottom", -- position of the list can be: bottom, top, left, right
				height = 10, -- height of the trouble list when position is top or bottom
				width = 50, -- width of the list when position is left or right
				icons = true, -- use devicons for filenames
				mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
				fold_open = "", -- icon used for open folds
				fold_closed = "", -- icon used for closed folds
				group = true, -- group results by file
				padding = true, -- add an extra new line on top of the list
				action_keys = { -- key mappings for actions in the trouble list
					-- map to {} to remove a mapping, for example:
					-- close = {},
					close = "q", -- close the list
					cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
					refresh = "r", -- manually refresh
					jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
					open_split = { "<c-x>" }, -- open buffer in new split
					open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
					open_tab = { "<c-t>" }, -- open buffer in new tab
					jump_close = { "o" }, -- jump to the diagnostic and close the list
					toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
					toggle_preview = "P", -- toggle auto_preview
					hover = "K", -- opens a small popup with the full multiline message
					preview = "p", -- preview the diagnostic location
					close_folds = { "zM", "zm" }, -- close all folds
					open_folds = { "zR", "zr" }, -- open all folds
					toggle_fold = { "zA", "za" }, -- toggle fold of current file
					previous = "k", -- preview item
					next = "j", -- next item
				},
				indent_lines = true, -- add an indent guide below the fold icons
				auto_open = false, -- automatically open the list when you have diagnostics
				auto_close = false, -- automatically close the list when you have no diagnostics
				auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
				auto_fold = false, -- automatically fold a file trouble list at creation
				auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
				signs = {
					-- icons / text used for a diagnostic
					error = "",
					warning = "",
					hint = "",
					information = "",
					other = "﫠",
				},
				use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
			}),
		})
	end,
})

Plug("ray-x/lsp_signature.nvim", {
	config = function()
		require("lsp_signature").setup({})
	end,
})

Plug("hrsh7th/cmp-nvim-lua")
Plug("saadparwaiz1/cmp_luasnip")
Plug("hrsh7th/cmp-nvim-lsp-signature-help")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-nvim-lua")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp", {
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			completion = { completeopt = "menu,menuone,noinsert" },
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = {
				["<c-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-e>"] = cmp.mapping.scroll_docs(4),
				["<c-y>"] = cmp.mapping.scroll_docs(-4),
				["<c-c>"] = cmp.mapping.close(),
				["<cr>"] = cmp.mapping.confirm({ select = true }),
			},
			sources = cmp.config.sources({
				{ name = "luasnip" },
				-- { name = "nvim_lsp_signature_help" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
				{ name = "nvim_lsp" },
				{ name = "path" },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text", -- show only symbol annotations
					maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

					-- The function below will be called before any actual modifications from lspkind
					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					before = function(_, vim_item)
						return vim_item
					end,
				}),
			},
		})
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

Plug("gpanders/nvim-parinfer")

Plug("L3MON4D3/LuaSnip", {
	config = function()
		map({ "i", "s", "n" }, "<tab>", function()
			if vim.fn["luasnip#expand_or_jumpable"]() then
				utils.feed_plug_keys("luasnip-expand-or-jump")
			else
				return "\t"
			end
		end, { expr = true })
		map({ "i", "s", "n" }, "<s-tab>", '<cmd>lua require"luasnip".jump(-1)<Cr>')
		map({ "i", "s", "n" }, "<c-s-j>", "<Plug>luasnip-next-choice")
		map({ "i", "s", "n" }, "<c-s-k>", "<Plug>luasnip-prev-choice")
		require("luasnip").config.set_config({
			history = true,
			-- Update more often, :h events for more info.
			update_events = "TextChanged,TextChangedI",
			-- Snippets aren't automatically removed if their text is deleted.
			-- `delete_check_events` determines on which events (:h events) a check for
			-- deleted snippets is performed.
			-- This can be especially useful when `history` is enabled.
			delete_check_events = "TextChanged",
			ext_opts = {
				[require("luasnip.util.types").choiceNode] = {
					active = {
						virt_text = { { "choiceNode", "Comment" } },
					},
				},
			},
			-- treesitter-hl has 100, use something higher (default is 200).
			ext_base_prio = 300,
			-- minimal increase in priority.
			ext_prio_increase = 1,
			enable_autosnippets = true,
			-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
			-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
			store_selection_keys = "<Tab>",
			-- luasnip uses this function to get the currently active filetype. This
			-- is the (rather uninteresting) default, but it's possible to use
			-- eg. treesitter for getting the current filetype by setting ft_func to
			-- require("luasnip.extras.filetype_functions").from_cursor (requires
			-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
			-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
			ft_func = require("luasnip.extras.filetype_functions").from_cursor,
		})
		require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets/luasnippets" })

		vim.api.nvim_create_user_command("LuaSnipEdit", function()
			require("luasnip.loaders").edit_snippet_files({
				edit = function(file)
					vim.cmd("Tabdrop " .. file)
				end,
			})
		end, {})
	end,
})

Plug("rhysd/vim-grammarous", { on_cmd = "GrammarousCheck" })

Plug("mfussenegger/nvim-dap", {
	config = function()
		_G.DapGetArgs = function(program, dap_run_co)
			program = program:gsub("/", "_")
			local dap_folder = vim.fn.stdpath("data") .. "/dap"
			vim.fn.mkdir(dap_folder, "p")
			local arg_file = ("%s/%s"):format(dap_folder, program)
			vim.cmd("split " .. arg_file)
			vim.cmd("silent! write")
			vim.bo.bufhidden = "wipe"
			vim.api.nvim_create_autocmd("Bufunload", {
				buffer = 0,
				once = true,
				callback = function()
					coroutine.resume(
						dap_run_co,
						vim.tbl_filter(function(e)
							return e and #e > 0
						end, vim.fn.readfile(arg_file))
					)
				end,
			})
		end
		local dap = require("dap")
		dap.adapters.python = {
			type = "executable",
			command = "python",
			args = { "-m", "debugpy.adapter" },
		}
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = function()
					return "python"
				end,
			},
		}

		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "attach",
				host = function()
					local value = vim.fn.input("Host [127.0.0.1]: ")
					if value ~= "" then
						return value
					end
					return "127.0.0.1"
				end,
				port = function()
					local val = tonumber(vim.fn.input("Port: "))
					assert(val, "Please provide a port number")
					return val
				end,
			},
		}
		dap.adapters.nlua = function(callback, config)
			callback({ type = "server", host = config.host, port = config.port })
		end

		vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint" })
		vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DapBreakpointCondition" })
		vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpointRejected" })
		vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint" })
		vim.fn.sign_define("DapStopped", {
			text = " ",
			texthl = "DapStopped",
			linehl = "DapStoppedLine",
		})
		local color = require("colorscheme").color
		require("colorscheme").add_plug_hl({
			DapBreakpoint = { fg = color.red },
			DapBreakpointCondition = { fg = color.red },
			DapStopped = { fg = color.green },
			DapStoppedLine = { bg = color.base4 },
		})

		vim.api.nvim_create_user_command("Debug", function()
			local debug_mappings = {
				n = {
					x = {
						callback = function()
							vim.cmd("DapStepOver")
						end,
					},
					s = {
						callback = function()
							vim.cmd("DapStepInto")
						end,
					},
					c = {
						callback = function()
							vim.cmd("DapContinue")
						end,
					},
					E = {
						callback = function()
							require("dapui").eval(nil, { enter = true })
						end,
					},
					B = {
						callback = function()
							vim.cmd("DapToggleBreakpoint")
						end,
					},
				},
				v = {
					E = {
						callback = function()
							require("dapui").eval(nil, { enter = true })
						end,
					},
				},
			}

			local bufnr = vim.api.nvim_get_current_buf()
			local lnum = vim.api.nvim_win_get_cursor(0)[1]
			require("dap.breakpoints").remove(bufnr, lnum)
			vim.cmd("DapToggleBreakpoint")
			local original_mappings = utils.save_keymap(debug_mappings)
			utils.restore_keymap(debug_mappings.n, "n")
			utils.restore_keymap(debug_mappings.v, "v")
			vim.o.mouse = "a"
			map("n", "T", function()
				utils.restore_keymap(original_mappings)
				vim.keymap.del("n", "T")
				vim.o.mouse = ""
				pcall(require("dap").terminate)
			end)
			vim.cmd("DapContinue")
		end, { nargs = "?" })
	end,
})

Plug("rcarriga/nvim-dap-ui", {
	config = function()
		local dapui = require("dapui")
		local dap = require("dap")
		dapui.setup({
			layouts = {
				{
					elements = {
						"repl",
					},
					size = 0.01,
					position = "top",
				},
				{
					elements = {
						"breakpoints",
						"stacks",
					},
					size = 0.3,
					position = "bottom",
				},
			},
			controls = {
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "↻",
					terminate = "□",
				},
				enabled = true,
				element = "breakpoints",
			},
		})
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
})

Plug("theHamsta/nvim-dap-virtual-text", {
	config = function()
		require("nvim-dap-virtual-text").setup({})
	end,
})

Plug("nvim-neotest/neotest")
Plug("nvim-neotest/neotest-plenary")

Plug("puremourning/vimspector")

Plug("git@github.com:ipod825/julia-unicode.vim", { ft = "julia" })

Plug("junegunn/vim-easy-align", {
	config = function()
		map("n", "ga", "<Plug>(EasyAlign)", { remap = true })
		map("x", "ga", "<Plug>(EasyAlign)", { remap = true })
	end,
})

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
				vim.fn["war#enter"]()
			end,
		})
		vim.api.nvim_create_autocmd("Filetype", {
			group = WAR,
			pattern = { "dapui_breakpoints", "dapui_stacks" },
			callback = function()
				vim.fn["war#fire"](0.8, 0.3, 0.5, 0.3)
			end,
		})
		vim.api.nvim_create_autocmd("Filetype", {
			group = WAR,
			pattern = { "dapui_repl", "dapui_console" },
			callback = function()
				vim.fn["war#fire"](0.8, 0.3, 0.5, 0.01)
			end,
		})
	end,
})

Plug("hkupty/iron.nvim", {
	disable = true,
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
	ft = "qf",
	config = function()
		require("bqf").setup({
			qf_win_option = {
				wrap = true,
				number = false,
				relativenumber = false,
			},
			func_map = {
				tabdrop = "<cr>",
				open = "<c-e>",
			},
			preview = { win_height = 35 },
		})
	end,
})

Plug("williamboman/mason.nvim", {
	config = function()
		require("mason").setup({
			ui = {
				keymaps = {
					toggle_package_expand = "<space><space>",
					install_package = "<cr>",
					update_package = "u",
					check_package_version = "c",
					update_all_packages = "U",
					check_outdated_packages = "C",
					uninstall_package = "X",
					cancel_installation = "<C-c>",
					apply_language_filter = "<C-f>",
				},
			},
		})
	end,
})
Plug("WhoIsSethDaniel/mason-tool-installer.nvim", {
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"clangd",
			},
			auto_update = true,
			run_on_start = false,
			start_delay = 3000,
		})
	end,
})
Plug("neovim/nvim-lspconfig")

Plug("jose-elias-alvarez/null-ls.nvim", {
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.jq,
				null_ls.builtins.formatting.trim_whitespace,
				null_ls.builtins.completion.spell,
			},
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

Plug("MattesGroeger/vim-bookmarks", {
	config = function() end,
})

Plug("kylechui/nvim-surround", {
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				visual = "s",
			},
		})
	end,
})

Plug("justinmk/vim-sneak", {
	config = function()
		vim.g["sneak#label"] = 1
		vim.g["sneak#absolute_dir"] = -4
		map("n", "f", "<Plug>Sneak_f", { remap = true })
		map("n", "F", "<Plug>Sneak_F", { remap = true })
		map("x", "f", "<Plug>Sneak_f", { remap = true })
		map("x", "F", "<Plug>Sneak_F", { remap = true })
		map("n", "L", "<Plug>Sneak_;")
		map("n", "H", "<Plug>Sneak_,")
		map("x", "L", "<Plug>Sneak_;")
		map("x", "H", "<Plug>Sneak_,")

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("SNEAK", {}),
			command = "highlight link Sneak None",
		})
	end,
})

Plug("machakann/vim-swap")

Plug("ipod825/vim-esearch", {
	branch = "fix_t_ve",
	setup = function()
		vim.g.esearch = {
			adapter = "rg",
			bckend = "nvim",
			out = "win",
			batch_size = 1000,
			default_mappings = 0,
			live_update = 1,
			win_ui_nvim_syntax = 1,
			root_markers = root_markers,
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
		local ESEARCH = vim.api.nvim_create_augroup("ESEARCH", {})
		vim.api.nvim_create_autocmd("Filetype", {
			group = ESEARCH,
			pattern = "esearch",
			callback = function()
				map("n", "yy", function()
					vim.cmd("normal! yy")
					vim.fn.setreg('"', vim.fn.getreg('"'):gsub("^%s*%d*%s*", ""))
				end)
			end,
		})
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = ESEARCH,
			command = "highlight! link esearchMatch Cursor",
		})
		map("n", "<leader>f", "<Plug>(operator-esearch-prefill)iw", { remap = true })
		map("x", "<leader>f", "<Plug>(esearch)", { remap = true })
		map("n", "<leader>F", '<cmd>call esearch#init({"prefill":["cword"], "paths": expand("%:p")})<cr>')
		map("x", "<leader>F", 'esearch#prefill({"paths": expand("%:p")})', { expr = true })
	end,
})

Plug("will133/vim-dirdiff", { on_cmd = "DirDiff" })

Plug("mrjones2014/smart-splits.nvim")

Plug("skywind3000/asyncrun.vim", {
	config = function()
		vim.g.asyncrun_pathfix = 1
		vim.g.asyncrun_open = 6
		local ASYNCRUN = vim.api.nvim_create_augroup("ASYNCRUN", {})
		vim.api.nvim_create_autocmd("User", {
			group = ASYNCRUN,
			pattern = "AsyncRunPre",
			callback = function()
				vim.cmd("wincmd o")
				vim.g.asyncrun_win = vim.api.nvim_get_current_win()
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = ASYNCRUN,
			pattern = "AsyncRunStop",
			callback = function()
				vim.api.nvim_set_current_win(vim.g.asyncrun_win)
				if vim.g.asyncrun_code == 0 then
					vim.cmd("cclose")
				else
					vim.fn.setqflist(vim.tbl_filter(function(e)
						return e.valid ~= 0
					end, vim.fn.getqflist()))
					vim.cmd("botright copen")
				end
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
-- 	config = function()
-- 		require("vgit").setup({ settings = { live_gutter = { enabled = false } } })
-- 	end,
-- })
-- Plug("TimUntersberger/neogit")

Plug("whiteinge/diffconflicts")

Plug("git@github.com:ipod825/libp.nvim", {
	config = function()
		require("libp").setup({
			integration = {
				web_devicon = {
					alias = { igit = "git", hg = "git" },
				},
			},
		})
	end,
})
Plug("git@github.com:ipod825/oldfiles.nvim", {
	config = function()
		require("oldfiles").setup()
	end,
})

Plug("git@github.com:ipod825/igit.nvim", {
	config = function()
		utils.cmdabbrev("G", "IGit status")
		utils.cmdabbrev("gbr", "IGit branch")
		utils.cmdabbrev("glg", "IGit log")
		utils.cmdabbrev("gps", "IGit push")
		utils.cmdabbrev("gpl", "IGit pull")
		utils.cmdabbrev("grc", "IGit rebase --continue")
		utils.cmdabbrev("gra", "IGit rebase --abort")
		utils.cmdabbrev(
			"glc",
			[[exec 'IGit log --branches --graph  --author="Shih-Ming Wang" --follow -- '.expand("%:p")]]
		)
		require("igit").setup({
			branch = {
				confirm_rebase = false,
			},
			log = { confirm_rebase = false, open_cmd = "Tabdrop" },
			status = { open_cmd = "Tabdrop" },
		})
	end,
})

Plug("andymass/vim-matchup")
Plug("AndrewRadev/linediff.vim", { on_cmd = { "LineDiffAdd" } })

Plug("chrisbra/Colorizer")
Plug("ziontee113/color-picker.nvim", {
	config = function()
		require("color-picker")
	end,
})
Plug("powerman/vim-plugin-AnsiEsc")

Plug("nvim-orgmode/orgmode", {
	config = function()
		require("orgmode").setup({})
		require("orgmode").setup_ts_grammar()
	end,
})

Plug("git@github.com:ipod825/ranger.nvim", {
	config = function()
		local action = require("ranger.action")
		local profile = require("profile")
		local fs = require("libp.fs")
		local uv = require("libp.fs.uv")
		require("ranger").setup({
			hijack_netrw = true,
			rifle_path = require("libp.utils.pathfn").join(vim.fn.stdpath("config"), "settings/rifle.conf"),
			mappings = {
				n = {
					["<leader>f"] = function()
						local _, node = action.utils.get_cur_buffer_and_node()
						if node.abspath then
							vim.fn["esearch#init"]({ paths = node.abspath, root_markers = {} })
						else
							vim.fn["esearch#init"]({ paths = vim.fn.getcwd(), root_markers = {} })
						end
					end,
					i = function()
						action.rename(profile.cur_env.ranger_rename_fn or uv.fs_rename)
					end,
					p = function()
						action.transfer.paste({
							copy_fn = function(...)
								(profile.cur_env.ranger_copy_fn or fs.copy)(...)
							end,
							rename_fn = function(...)
								(profile.cur_env.ranger_rename_fn or uv.fs_rename)(...)
							end,
						})
					end,
				},
			},
		})
	end,
})

Plug("rbtnn/vim-vimscript_lasterror")

Plug("git@github.com:ipod825/hg.nvim", {
	config = function()
		utils.cmdabbrev("hg", "Hg")
		utils.cmdabbrev("hlg", "Hg log")
		utils.cmdabbrev("hlgm", "Hg log -G -f -u " .. vim.env.USER)
		utils.cmdabbrev("H", "Hg status")
		utils.cmdabbrev("HH", 'Hg status --rev "parents(min(.))"')
		require("hg").setup({
			hg_sub_commands = { "uc" },
			status = {
				open_cmd = "Tabdrop",
			},
			log = {
				open_cmd = "Tabdrop",
			},
		})
	end,
})

Plug.ends()

return M
