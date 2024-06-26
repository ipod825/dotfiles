local utils = require("utils")

return {
	url = "sso://user/smwang/hg.nvim",
	cmd = "Hg",
	init = function()
		utils.cmdabbrev("hg", "Hg")
		utils.cmdabbrev("hlg", "Hg log")
		utils.cmdabbrev("hlgm", "Hg log -G -f -u " .. vim.env.USER)
		utils.cmdabbrev("H", "Hg status")
		utils.cmdabbrev("HH", 'Hg status --rev "parents(min(.))"')
	end,
	config = function()
		require("hg").setup({
			hg_sub_commands = { "uc", "ut" },
			status = {
				open_cmd = "Tabdrop",
				buf_enter_reload = false,
			},
			log = {
				open_cmd = "Tabdrop",
				buf_enter_reload = false,
			},
		})
	end,
}
