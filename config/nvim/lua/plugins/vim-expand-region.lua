return {
		"git@github.com:ipod825/vim-expand-region",
		init = function()
			vim.g.vim_textobj_parameter_mapping = ","
			vim.g.expand_region_text_objects = {
				["iw"] = 0,
				['i"'] = 0,
				['a"'] = 0,
				["i'"] = 0,
				["a'"] = 0,
				["i]"] = 1,
				["a]"] = 1,
				["i)"] = 1,
				["a)"] = 1,
				["i}"] = 1,
				["i,"] = 0,
				["a,"] = 0,
				["if"] = 0,
				["il"] = 0,
				["ip"] = 0,
				["ix"] = 0,
				["ax"] = 0,
			}
		end,
		config = function()
			local EXPANDREGION = vim.api.nvim_create_augroup("EXPANDREGION", {})
			vim.api.nvim_create_autocmd("User", {
				group = EXPANDREGION,
				pattern = "ExpandRegionStart",
				callback = function()
					vim.keymap.del("n", "8")
					vim.keymap.del("x", "8")
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = EXPANDREGION,
				pattern = "ExpandRegionStop",
				callback = function()
					vim.keymap.set("n", "8", "<Plug>MSToggleAddCword", { remap = true })
					vim.keymap.set("x", "8", "<Plug>MSToggleAddVisual", { remap = true })
				end,
			})
			vim.keymap.set("x", "<m-k>", "<Plug>(expand_region_expand)", { remap = true })
			vim.keymap.set("x", "<m-j>", "<Plug>(expand_region_shrink)", { remap = true })
			vim.keymap.set("n", "<m-k>", "<Plug>(expand_region_expand)", { remap = true })
			vim.keymap.set("n", "<m-j>", "<Plug>(expand_region_shrink)", { remap = true })
		end,
	}
