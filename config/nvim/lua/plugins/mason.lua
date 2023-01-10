return {
	"williamboman/mason.nvim",
	dependencies = {{
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"python-lsp-server",
				"lua-language-server",
				"stylua",
				"clangd",
			},
			auto_update = true,
			run_on_start = false,
			start_delay = 3000,
		})
	end,
}},
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
}
