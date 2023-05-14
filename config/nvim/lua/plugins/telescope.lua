return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope._extensions.fzf").setup({
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
				}, {})
				require("telescope").load_extension("fzf")
			end,
		},
		 {
  'prochri/telescope-all-recent.nvim',
  config = function()
    require'telescope-all-recent'.setup{
    }
  end
}
	},
	config = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local action_set = require("telescope.actions.set")
		local select_to_edit_map = {
			default = "edit",
			horizontal = "new",
			vertical = "vnew",
			tab = "tabedit",
			force_edit = "edit",
		}
		require("telescope.actions.state").select_key_to_edit_key = function(type)
			local entry = action_state.get_selected_entry()
			local filepath = entry[1]
			local cwd = entry.cwd or ""
			if
				(
					vim.fn.filereadable(filepath) ~= 0
					or vim.fn.filereadable(require("libp.utils.pathfn").join(cwd, filepath)) ~= 0
				) and type ~= "force_edit"
			then
				return "Tabdrop"
			else
				return select_to_edit_map[type]
			end
		end
		local myactions = require("telescope.actions.mt").transform_mod({
			select_force_edit = {
				pre = function(prompt_bufnr)
					action_state
						.get_current_history()
						:append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
				end,
				action = function(prompt_bufnr)
					return action_set.select(prompt_bufnr, "force_edit")
				end,
			},
		})
		-- Why do we even need this?
		vim.api.nvim_create_autocmd("Filetype", {
			group = vim.api.nvim_create_augroup("TELESCOPE", {}),
			pattern = "TelescopePrompt",
			callback = function()
				vim.keymap.set("n", "p", function()
					local text = vim.fn.getreg('"'):gsub("\n$", "")
					vim.fn.feedkeys("i" .. text, "n")
				end, { buffer = 0 })
			end,
		})

		local full = 9999
		require("telescope").setup({
			defaults = {
				scroll_strategy = "limit",
				winblend = 10,
				sorting_strategy = "ascending",
				multi_icon = "* ",
				path_display = function(_, path)
					path = path:gsub(vim.env.HOME, "~")
					for _, env in pairs(require("profile").envs) do
						if env.telescope_path_display then
							path = env.telescope_path_display(path)
						end
					end
					return path
				end,
				layout_strategy = "vertical",
				-- file_ignore_patterns = { "doc.*html$" },
				borderchars = {
					prompt = { "─", " ", " ", " ", " ", " ", " ", " " },
					results = { "─", " ", " ", " ", " ", " ", " ", " " },
					preview = { "─", " ", " ", " ", " ", " ", " ", " " },
				},
				layout_config = {
					horizontal = {
						height = full,
						width = full,
						preview_width = 0.7,
						prompt_position = "top",
					},
					vertical = {
						mirror = true,
						height = full,
						width = full,
						prompt_position = "top",
						preview_height = 0.6,
						preview_cutoff = 0,
					},
				},
				mappings = {
					i = {
						["<cr>"] = actions.select_default,
						["<c-e>"] = myactions.select_force_edit,
						["<c-j>"] = actions.move_selection_next,
						["<c-k>"] = actions.move_selection_previous,
						["<c-b>"] = actions.results_scrolling_up,
						["<c-f>"] = actions.results_scrolling_down,
						["<c-n>"] = actions.cycle_history_next,
						["<c-p>"] = actions.cycle_history_prev,
						["<c-u>"] = function()
							vim.cmd([[normal! "_dd]])
						end,
					},
					n = {
						["<cr>"] = actions.select_default,
						["<c-e>"] = myactions.select_force_edit,
						["<C-c>"] = actions.close,
						["<c-b>"] = actions.results_scrolling_up,
						["<c-f>"] = actions.results_scrolling_down,
						["<c-n>"] = actions.cycle_history_next,
						["<c-p>"] = actions.cycle_history_prev,
					},
				},
			},
		})

		require("colorscheme").add_plug_hl({
			TelescopeSelection = { default = true, link = "Pmenu" },
			TelescopeBorder = { default = true, link = "Label" },
		})

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local builtin = require("telescope.builtin")

		require("utils").cmdabbrev(
			"help",
			"lua require'telescope.builtin'.help_tags({default_text=''})<left><left><left>"
		)

		vim.keymap.set("n", "<c-p>", function()
			builtin.fd({ cwd = require("libp.utils.pathfn").find_directory(require("plugins").root_markers) })
		end)

		vim.keymap.set("n", "/", function()
			builtin.current_buffer_fuzzy_find()
			-- builtin.current_buffer_fuzzy_find({
			-- 	previewer = false,
			-- })
		end)

		vim.keymap.set("n", "z=", function()
			builtin.spell_suggest()
		end)

		vim.keymap.set("n", "<leader>b", builtin.buffers)

		local cached_config_files
		vim.keymap.set("n", "<leader>e", function()
			local opts = {}
			cached_config_files = cached_config_files
				or vim.tbl_filter(
					function(e)
						return vim.fn.isdirectory(e) == 0
					end,
					vim.split(
						vim.fn.glob("$HOME/dotfiles/**/.[^.]*") .. "\n" .. vim.fn.glob("$HOME/dotfiles/**/*"),
						"\n"
					)
				)
			pickers
				.new(opts, {
					finder = finders.new_table({
						results = cached_config_files,
					}),
					previewer = conf.file_previewer(opts),
					sorter = conf.file_sorter(opts),
					entry_maker = require("telescope.make_entry").gen_from_file(opts),
				})
				:find()
		end)
	end,
}
