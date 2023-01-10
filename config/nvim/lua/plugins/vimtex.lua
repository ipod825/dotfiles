return {
		"lervag/vimtex",
		ft = "tex",
		config = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_fold_enabled = 1
			vim.g.vimtex_log_ignore = { "25" }
			vim.g.vimtex_view_general_viewer = "zathura"
			vim.g.tex_conceal = "abdgm"
		end,
	}
