local utils  = require("utils")
return {
		"mg979/vim-visual-multi",
		lazy=false,
		branch = "test",
		init = function()
			vim.g.VM_default_mappings = 0
			vim.keymap.set("n", "<leader>m", function()
				vim.cmd("VMSearch " .. vim.fn["msearch#joint_pattern"]())
				utils.feed_plug_keys("(VM-Select-All)")
				utils.feed_plug_keys("(VM-Goto-Prev)")
			end, { desc = "select all marks" })
			vim.keymap.set("x", "<leader>m", function()
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
					vim.keymap.set("i", "jk", "<esc>", { buffer = true })
					vim.keymap.set("i", "<c-h>", "<left>", { buffer = true, remap = true })
					vim.keymap.set("i", "<c-l>", "<right>", { buffer = true, remap = true })
					vim.keymap.set("i", "<c-j>", "<down>", { buffer = true, remap = true })
					vim.keymap.set("i", "<c-k>", "<up>", { buffer = true, remap = true })
					vim.keymap.set("i", "<m-h>", "<esc><m-h>i", { buffer = true, remap = true })
					vim.keymap.set("i", "<m-l>", "<esc><m-l>i", { buffer = true, remap = true })
					vim.keymap.set("n", "J", "<down>", { buffer = true })
					vim.keymap.set("n", "K", "<up>", { buffer = true })
					vim.keymap.set("n", "H", "<Left>", { buffer = true })
					vim.keymap.set("n", "L", "<Right>", { buffer = true })
					vim.keymap.set("n", "<c-c>", "<Esc>", { buffer = true })
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = VISUAL_MULTI,
				pattern = "visual_multi_exit",
				callback = function()
					vim.keymap.del("i", "jk", { buffer = true })
					vim.keymap.del("i", "<c-h>", { buffer = true })
					vim.keymap.del("i", "<c-l>", { buffer = true })
					vim.keymap.del("i", "<c-j>", { buffer = true })
					vim.keymap.del("i", "<c-k>", { buffer = true })
					vim.keymap.del("i", "<m-h>", { buffer = true })
					vim.keymap.del("i", "<m-l>", { buffer = true })
					vim.keymap.del("n", "J", { buffer = true })
					vim.keymap.del("n", "K", { buffer = true })
					vim.keymap.del("n", "H", { buffer = true })
					vim.keymap.del("n", "L", { buffer = true })
					vim.keymap.del("n", "<c-c>", { buffer = true })
				end,
			})
		end,
	}
