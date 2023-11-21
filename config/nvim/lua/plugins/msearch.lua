local utils = require("utils")
local function normal_toggle_add_word()
	local cword = vim.fn.expand("<cword>")
	if vim.startswith(cword, "FLAGS_") then
		vim.cmd("normal viwof_l")
		utils.feed_plug_keys("MSToggleAddVisual")
	else
		utils.feed_plug_keys("MSToggleAddCword")
	end
end

return {
	"git@github.com:ipod825/msearch.vim",
	config = function()
		vim.keymap.set("n", "8", normal_toggle_add_word)
		vim.keymap.set("x", "8", "<Plug>MSToggleAddVisual", { remap = true })
		vim.keymap.set("n", "*", "<Plug>MSExclusiveAddCword", { remap = true })
		vim.keymap.set("x", "*", "<Plug>MSExclusiveAddVisual", { remap = true })
		vim.keymap.set("n", "n", "<Plug>MSNext", { remap = true })
		vim.keymap.set("n", "N", "<Plug>MSPrev", { remap = true })
		vim.keymap.set("o", "n", "<Plug>MSNext", { remap = true })
		vim.keymap.set("o", "N", "<Plug>MSPrev", { remap = true })
		vim.keymap.set("n", "<leader>n", "<Plug>MSToggleJump", { remap = true })
		vim.keymap.set("n", "<leader>/", "<Plug>MSClear", { remap = true })
		vim.keymap.set("n", "?", "<Plug>MSAddBySearchForward", { remap = true })
	end,
	normal_toggle_add_word = normal_toggle_add_word,
}
