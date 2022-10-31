local M = {}

local map = vim.keymap.set
local vimfn = require("libp.utils.vimfn")
local functional = require("libp.functional")

-- Mode Changing
map("n", ";", ":")
map("i", "jk", "<esc>l")
map({ "c", "o", "s" }, "jk", "<esc>")
map("c", "<m-d>", "<c-f>dwi")
map("x", "<cr>", "<esc>")
map("i", "<c-a>", "<esc><c-w>")

-- Moving Around
map("n", "j", "gj")
map("n", "k", "gk")
map("i", "<c-h>", "<left>")
map("i", "<c-l>", "<right>")
map("i", "<c-j>", "<down>")
map("i", "<c-k>", "<up>")
map("n", "<cr>", function()
	if vim.wo.diff then
		local ori_w = vim.api.nvim_get_current_win()
		for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if w ~= ori_w and vim.api.nvim_win_get_option(w, "diff") then
				vim.api.nvim_set_current_win(w)
				return
			end
		end
	else
		vim.cmd("wincmd w")
	end
end, { desc = "next window" })
map({ "n", "x" }, "<c-k>", function()
	if vim.bo.buftype ~= "terminal" then
		local ori_line = vimfn.getrow()
		vim.cmd("normal! {")
		if vimfn.getrow() == ori_line - 1 then
			vim.cmd("normal! {")
		end
		if vimfn.getrow() ~= 1 then
			vim.cmd("normal! j")
		end
	else
		vim.fn.search(vim.env.USER, "Wbz")
	end
end, { desc = "previous _block" })
map({ "n", "x" }, "<c-j>", function()
	if vim.bo.buftype ~= "terminal" then
		local ori_line = vimfn.getrow()
		vim.cmd("normal! }")
		if vimfn.getrow() == ori_line + 1 then
			vim.cmd("normal! }")
		end
		if vimfn.getrow() ~= vim.fn.line("$") then
			vim.cmd("normal! k")
		end
	else
		vim.fn.search(vim.env.USER, "Wbz")
	end
end, { desc = "next block" })

-- Moving Around (home,END)
map({ "o", "n" }, "<m-h>", "g^")
map({ "o", "n" }, "<m-l>", "g$")
map("x", "<m-h>", "g^")
map("x", "<m-l>", "g$<left>")
map("i", "<m-h>", "<Esc>g^i")
map("i", "<m-l>", "<Esc>g_i")
map("c", "<m-h>", "<c-b>")
map("c", "<m-l>", "<c-e>")
map("t", "<m-h>", "<home>")
map("t", "<m-l>", "<end>")
function M.previous_block()
	if vim.bo.buftype ~= "terminal" then
		local ori_line = vimfn.getrow()
		vim.cmd("normal! {")
		if vimfn.getrow() == ori_line - 1 then
			vim.cmd("normal! {")
		end
		if vimfn.getrow() ~= 1 then
			vim.cmd("normal! j")
		end
	else
		vim.fn.search(vim.env.USER, "Wbz")
	end
end

-- Terminal
vim.api.nvim_create_user_command("ToggleTermInsert", function()
	vim.b.auto_term_insert = not vim.b.auto_term_insert
	if vim.b.auto_term_insert then
		vim.cmd("startinsert")
	end
end, {})
function M.open_term(open_cmd)
	vim.cmd(open_cmd)
	vim.cmd("term")
	vim.b.auto_term_insert = true
	vim.cmd("startinsert")
	vim.api.nvim_create_autocmd("BufEnter", {
		buffer = 0,
		callback = function()
			if vim.b.auto_term_insert then
				vim.cmd("startinsert")
			end
		end,
	})
end
M.id_to_term = M.id_to_term or {}
function M.reuse_term(open_cmd, id)
	id = id or "default"
	if M.id_to_term[id] == nil then
		M.open_term(open_cmd)
		M.id_to_term[id] = vim.api.nvim_buf_get_name(0)
		vim.api.nvim_create_autocmd("BufUnload", {
			buffer = 0,
			callback = function()
				M.id_to_term[id] = nil
			end,
		})
		map("t", "<c-d>", [[<c-\><c-n>:quit<cr>]], { buffer = true })
		return false
	else
		vim.cmd(string.format("%s %s", open_cmd, M.id_to_term[id]))
		return true
	end
end
map("n", "<m-t>", function()
	M.reuse_term("Tabdrop", vim.fn.getcwd())
end)
map("n", "<m-o>", function()
	M.reuse_term("split", vim.fn.getcwd())
end)
map("n", "<m-e>", function()
	M.reuse_term("vsplit", vim.fn.getcwd())
end)
map("n", "<m-s-t>", functional.bind(M.open_term, "Tabdrop"))
map("n", "<m-s-o>", functional.bind(M.open_term, "split"))
map("n", "<m-s-e>", functional.bind(M.open_term, "vsplit"))
map("t", "jk", [[<c-\><c-n>]])
map("t", "<esc>", [[<c-\><c-n>]])
map("t", "<c-a>", [[<c-\><c-n><c-w>]])
map("t", "<c-z>", "<c-v><c-z>")
map("t", "<c-k>", "<up>")
map("t", "<c-j>", "<down>")
map("c", "<c-k>", "<up>")
map("c", "<c-j>", "<down>")

local ori_timeout_len = vim.o.timeoutlen
map("t", "<m-j>", function()
	if vim.b.no_jk == nil then
		vim.api.nvim_create_autocmd("BufEnter", {
			buffer = 0,
			callback = function()
				if vim.b.no_jk then
					vim.o.timeoutlen = 10
				end
			end,
		})
		vim.api.nvim_create_autocmd("BufLeave", {
			buffer = 0,
			callback = function()
				if vim.b.no_jk then
					vim.o.timeoutlen = ori_timeout_len
				end
			end,
		})
	end
	vim.b.no_jk = not vim.b.no_jk

	if vim.b.no_jk then
		vim.o.timeoutlen = 10
	else
		vim.o.timeoutlen = ori_timeout_len
	end
end, { desc = "toggle term nojk" })

-- Tab switching
map("n", "<c-h>", "gT")
map("n", "<c-l>", "gt")
map("n", "<c-m-h>", ":tabmove -1<cr>")
map("n", "<c-m-l>", ":tabmove +1<cr>")
map("t", "<c-h>", "jkgT", { remap = true })
map("t", "<c-l>", "jkgt", { remap = true })
map("n", "<c-m-j>", function()
	if vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()) == 1 then
		vim.cmd("wincmd T")
		vim.cmd("silent! tabmove -1")
	else
		local current_buf = vim.api.nvim_get_current_buf()
		vim.cmd("normal! gT")
		local target_tab_page = vim.api.nvim_get_current_tabpage()
		vim.cmd("normal! gt")
		vim.cmd("close")
		vim.api.nvim_set_current_tabpage(target_tab_page)
		vim.cmd(string.format("vsplit | wincmd L | b%d", current_buf))
	end
end, { desc = "move to previous tab" })

map("n", "<c-m-k>", function()
	if vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()) == #vim.api.nvim_list_tabpages() then
		vim.cmd("wincmd T")
	else
		local current_buf = vim.api.nvim_get_current_buf()
		vim.cmd("normal! gt")
		local target_tab_page = vim.api.nvim_get_current_tabpage()
		vim.cmd("normal! gT")
		vim.cmd("close")
		vim.api.nvim_set_current_tabpage(target_tab_page)
		vim.cmd(string.format("vsplit | wincmd L | b%d", current_buf))
	end
end, { desc = "move to next tab" })

-- Window
map({ "i", "n" }, "<c-a>", "<Esc><c-w>")
map("n", "<c-m-down>", "<c-w>+")
map("n", "<c-m-up>", "<c-w>-")
map("n", "<c-m-left>", "<c-w><")
map("n", "<c-m-right>", "<c-w>>")
map("n", "q", "<cmd>quit<cr>")
map("n", "Q", "q")
map("n", "<m-w>", "<cmd>setlocal wrap!<cr>")

function M.close_float_windows()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
			print("Closing window", win)
		end
	end
end

vim.env.SUDO_ASKPASS = "/usr/bin/ssh-askpass"
vim.cmd("cnoreabbrev te Tabdrop")
vim.cmd("cnoreabbrev tc tabclose")
vim.cmd("cnoreabbrev sudow w !sudo -A tee % > /dev/null")
vim.cmd("cnoreabbrev man Man")
map("c", "qq", ":bwipeout<cr>")

-- misc
-- paste yanked text in command line
map("c", "<m-p>", '<c-r>"')
map("n", "gp", function()
	return ("`[%s`]"):format(vim.fn.strpart(vim.fn.getregtype(), 0, 1))
end, { expr = true })
-- paste current file name in command line
map("c", "<m-f>", "<c-r>%<c-f>")
-- yank to system clipboard
map("x", "<m-y>", function()
	local should_strip = vim.bo.buftype == "terminal" and vim.fn.mode() == "V"
	vim.cmd('silent! normal! "+y')
	if should_strip then
		local src = vim.fn.getreg("+")
		local w = vim.api.nvim_win_get_width(0)
		local res, _ = string.gsub(src, "([^\n]+)\n", function(s)
			if #s == w then
				return s
			else
				return s .. "\n"
			end
		end)
		vim.fn.setreg("+", res)
	end
end, { desc = "yank to system clipboard" })
map("x", "y", "y`]")
map("n", "U", function()
	if vim.bo.filetype == "python" then
		vim.bo.textwidth = 79
	else
		vim.bo.textwidth = 80
	end
	vim.cmd("normal! gwj")
	vim.bo.textwidth = 0
end, { desc = "comment_unwrap" })
map("n", "<F5>", function()
	local pathfn = require("libp.utils.pathfn")
	local plugin = vim.split(pathfn.basename(pathfn.find_directory(".git")), "%.")[1]

	for _, buffer in pairs(require("libp.global")("libp").buffers) do
		vim.cmd("bwipe " .. buffer.id)
	end
	require("vplug").reload(plugin)
end)
-- folding
map("n", "<leader><space>", "za", { remap = true })
map("n", "<leader>z", "zMzvzz")
-- shift
map("n", ">", ">>")
map("n", "<", "<<")
map("x", ">", ">gv")
map("x", "<", "<gv")

local function exec_diff_cmd(cmd, beg, ends)
	if beg ~= ends then
		vim.cmd(("%d,%d %s"):format(beg, ends, cmd))
	else
		vim.cmd(cmd)
	end
end

-- Diff
function M.diff_get()
	local beg, ends = vimfn.visual_rows()
	if #vim.api.nvim_tabpage_list_wins(0) == 3 then
		exec_diff_cmd("diffget ~other", beg, ends)
	else
		if vim.fn.winnr() == 1 then
			exec_diff_cmd("diffget", beg, ends)
		else
			exec_diff_cmd("diffput", beg, ends)
		end
	end
	vimfn.ensure_exit_visual_mode()
end
function M.diff_put()
	local beg, ends = vimfn.visual_rows()
	if #vim.api.nvim_tabpage_list_wins(0) == 3 then
		exec_diff_cmd("diffget ~base", beg, ends)
	else
		if vim.fn.winnr() == 2 then
			exec_diff_cmd("diffget", beg, ends)
		else
			exec_diff_cmd("diffput", beg, ends)
		end
	end
	vimfn.ensure_exit_visual_mode()
end
map("n", "<leader>h", M.diff_get)
map("n", "<leader>l", M.diff_put)
map("x", "<leader>h", M.diff_get)
map("x", "<leader>l", M.diff_put)

return M
