return {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonUpdate", "MasonInstall" },
	dependencies = {
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
			config = function()
				require("mason-tool-installer").setup({
					ensure_installed = {
						"python-lsp-server",
						"lua-language-server",
						"stylua",
						"clangd",
					},
					auto_update = true,
					run_on_start = true,
					start_delay = 3000,
				})
			end,
		},
	},
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
