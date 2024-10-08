return {
	"monkoose/neocodeium",
	enabled = true,
	event = "VeryLazy",
	filter = function()
		return require("profile").is_in_default_env()
	end,
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()

		-- local cmp = require("cmp")
		-- cmp.event:on("menu_opened", function()
		-- 	neocodeium.clear()
		-- end)
	end,
}
