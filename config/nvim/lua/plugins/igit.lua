local utils = require("utils")

return {
	"git@github.com:ipod825/igit.nvim",
	config = function()
		utils.cmdabbrev("G", "IGit status")
		utils.cmdabbrev("gbr", "IGit branch")
		utils.cmdabbrev("glg", "IGit log")
		utils.cmdabbrev("gps", "IGit push")
		utils.cmdabbrev("gpl", "IGit pull")
		utils.cmdabbrev("grc", "IGit rebase --continue")
		utils.cmdabbrev("gra", "IGit rebase --abort")
		utils.cmdabbrev(
			"glc",
			[[exec 'IGit log --branches --graph  --author="Shih-Ming Wang" --follow -- '.expand("%:p")]]
		)
		require("igit").setup({
			branch = {
				confirm_rebase = false,
			},
			log = { confirm_rebase = false, open_cmd = "Tabdrop" },
			status = { open_cmd = "Tabdrop" },
		})
	end,
}
