return {
	"monkoose/neocodeium",
	enabled = false,
	event = "VeryLazy",
	filter = function()
		return require("profile").is_in_default_env()
	end,
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<Tab>", neocodeium.accept)

		local cmp = require("cmp")
		cmp.event:on("menu_opened", function()
			neocodeium.clear()
		end)

		cmp.setup({
			completion = {
				autocomplete = false,
			},
		})
	end,
}
