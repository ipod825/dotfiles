return {
		"L3MON4D3/LuaSnip",
		lazy=false,
		cmd="LuaSnipEdit",
		config =
		function()
			vim.keymap.set({ "i", "s", "n" }, "<tab>", function()
				if vim.fn["luasnip#expand_or_jumpable"]() then
					require("utils").feed_plug_keys("luasnip-expand-or-jump")
				else
					return "\t"
				end
			end, { expr = true })
			vim.keymap.set({ "i", "s", "n" }, "<s-tab>", '<cmd>lua require"luasnip".jump(-1)<Cr>')
			vim.keymap.set({ "i", "s", "n" }, "<c-s-j>", "<Plug>luasnip-next-choice")
			vim.keymap.set({ "i", "s", "n" }, "<c-s-k>", "<Plug>luasnip-prev-choice")
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
			require("luasnip.loaders.from_lua").lazy_load({
				paths = vim.fn.stdpath("config") .. "/snippets/luasnippets",
			})

			vim.api.nvim_create_user_command("LuaSnipEdit", function()
				require("luasnip.loaders").edit_snippet_files({
					edit = function(file)
						vim.cmd("Tabdrop " .. file)
					end,
				})
			end, {})
		end,
	}
