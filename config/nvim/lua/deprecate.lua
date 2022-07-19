Plug("hrsh7th/cmp-vsnip", { disable = true })
Plug("hrsh7th/vim-vsnip-integ", { disable = true })
Plug("hrsh7th/vim-vsnip", {
	disable = true,
	setup = function()
		vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets/vsnip"
	end,
	config = function()
		map(
			"i",
			"<tab>",
			'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<tab>"',
			{ expr = true, remap = true }
		)
		map("i", "<s-tab>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true, remap = true })
		map("s", "<tab>", 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<tab>"', { expr = true, remap = true })
		map("s", "<s-tab>", 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true, remap = true })
	end,
})
