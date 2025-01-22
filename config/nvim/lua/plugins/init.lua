local M = {
	root_markers = { ".git", ".hg", ".svn", ".bzr", "_darcs", ".root" },
	{
		"SmiteshP/nvim-navic",
		event = "VeryLazy",
		config = true,
	},
	{ "rcarriga/nvim-notify" },
	{ "Susensio/magic-bang.nvim", config = true },
	{ "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
	{ "tridactyl/vim-tridactyl" },
	{ "wsdjeg/vim-fetch" },
	{ "git@github.com:ipod825/vim-tabdrop", event = "VeryLazy" },
	{ "RRethy/nvim-treesitter-endwise" },
	{ "windwp/nvim-ts-autotag" },
	{ "haringsrob/nvim_context_vt" },
	{ "tpope/vim-abolish", event = "VeryLazy" },
	{ "tami5/sqlite.lua" },
	{ "jubnzv/virtual-types.nvim" },
	{ "junegunn/fzf", build = ":call fzf#install()" },
	{ "voldikss/vim-translator", cmd = "TranslateW" },
	{ "onsails/lspkind.nvim" },
	{ "ray-x/lsp_signature.nvim" },
	{ "rhysd/vim-grammarous", cmd = "GrammarousCheck" },
	{ "nvim-neotest/neotest" },
	{ "neovim/nvim-lspconfig" },
	{ "majutsushi/tagbar", event = "VeryLazy" },
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "machakann/vim-swap" },
	{ "LukasPietzschmann/telescope-tabs" },
	{ "will133/vim-dirdiff", cmd = "DirDiff" },
	{ "mrjones2014/smart-splits.nvim" },
	{ "whiteinge/diffconflicts" },
	{ "git@github.com:ipod825/oldfiles.nvim", config = true },
	{ "andymass/vim-matchup" },
	{ "AndrewRadev/linediff.vim", event = "VeryLazy" },
	{ "chrisbra/Colorizer" },
	{ "ziontee113/color-picker.nvim" },
	{ "rbtnn/vim-vimscript_lasterror" },
	{ url = "sso://user/jackcogdill/nvim-figtree" },
	{ url = "sso://user/vvvv/ai.nvim" },
	{ "mhinz/vim-signify" },
}

local LAZY = vim.api.nvim_create_augroup("LAZY", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
	group = LAZY,
	pattern = "*/plugins/*.lua",
	callback = function(event)
		local file_name = string.sub(event.file, 1, -5)
		local lazy_root = vim.fn.stdpath("data") .. "/lazy"
		for name, _ in vim.fs.dir(lazy_root) do
			for affix in vim.iter({ "", "nvim", "vim" }) do
				if file_name == name .. "." .. affix then
					require("lazy.core.loader").reload(name)
					return
				end
			end
		end
	end,
})

return M
