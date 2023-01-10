return {
		"hkupty/iron.nvim",
		enabled = false,
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
	}
