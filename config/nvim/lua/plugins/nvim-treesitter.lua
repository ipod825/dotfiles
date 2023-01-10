return {
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
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
	}
