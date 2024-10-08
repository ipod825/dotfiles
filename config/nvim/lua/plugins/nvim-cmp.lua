return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lua",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-cmdline",
	},
	config = function()
		local cmp = require("cmp")
		local neocodeium = require("neocodeium")
		function do_cmp_or_neocodium(cmp_fn, neocodium_fn)
			return cmp.mapping(function(fallback)
				if cmp_fn and cmp.visible() then
					cmp_fn()
				elseif neocodium_fn and neocodeium and neocodeium.visible() then
					neocodium_fn()
				else
					fallback()
				end
			end)
		end
		cmp.setup({
			completion = { completeopt = "menu,menuone,noinsert" },
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = {
				["<c-j>"] = do_cmp_or_neocodium(
					cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					neocodeium.cycle
				),
				["<c-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-e>"] = cmp.mapping.scroll_docs(4),
				["<c-y>"] = cmp.mapping.scroll_docs(-4),
				["<c-c>"] = cmp.mapping.close(),
				["<cr>"] = do_cmp_or_neocodium(cmp.confirm, nil),
				["<tab>"] = do_cmp_or_neocodium(nil, neocodeium.accept),
			},
			sources = cmp.config.sources({
				{ name = "buganizer" },
				{ name = "nvim_ciderlsp" },

				{ name = "codeium" },
				{ name = "luasnip" },
				-- { name = "nvim_lsp_signature_help" },
				{ name = "nvim_lua" },
				{ name = "fuzzy_buffer" },
				{ name = "buffer" },
				{ name = "nvim_lsp" },
				{ name = "path" },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			confirmation = {
				default_behavior = cmp.ConfirmBehavior.Replace,
			},

			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text", -- show only symbol annotations
					maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

					-- The function below will be called before any actual modifications from lspkind
					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					before = function(_, vim_item)
						return vim_item
					end,
				}),
			},
			experimental = {
				ghost_text = false,
			},
		})

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
