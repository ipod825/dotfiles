return {
	"git@github.com:ipod825/libp.nvim",
	config = function()
		require("libp").setup({
			integration = {
				web_devicon = {
					alias = { igit = "git", hg = "git" },
				},
			},
		})
	end,
}
