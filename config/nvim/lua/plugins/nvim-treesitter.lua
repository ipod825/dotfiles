return {
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
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
	},

	{
		"mfussenegger/nvim-treehopper",
		keys = { { "m", mode = { "o", "x" } } },
		config = function()
			vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = false,
		event = "BufReadPre",
		config = true,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		enabled = false,
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
	},
	{
		"p00f/nvim-ts-rainbow",
		config = function()
			require("nvim-treesitter.configs").setup({
				rainbow = {
					enable = false,
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
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy=false,
		build = ":TSUpdate",
		config = function()
			local color = require("colorscheme").color
			local languages = {
				"bash",
				"cpp",
				"java",
				"javascript",
				"lua",
				"python",
				"kotlin",
				"org",
				"sql",
				"vim",
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
	},
}
