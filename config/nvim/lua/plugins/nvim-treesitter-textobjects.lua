return {
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
	}
