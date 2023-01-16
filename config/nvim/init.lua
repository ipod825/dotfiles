vim.g.mapleader = " "
vim.o.syntax = "on"
vim.o.filetype = "on"
vim.o.hidden = true
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.wildignore = [[*/.git/*,*.o,*.class,*.pyc,*.aux,*.fls,*.pdf,*.fdb_latexmk]]
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.background = "dark"
vim.o.autoread = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0
vim.o.diffopt = vim.o.diffopt .. ",vertical,followwrap"
vim.o.diffopt = vim.o.diffopt .. ",vertical"
vim.o.virtualedit = "block"
vim.o.showmatch = true
vim.o.cursorline = true
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true
vim.o.lazyredraw = true
vim.o.showmode = false
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.switchbuf = "usetab"
vim.o.mouse = ""
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.winminwidth = 0
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.scrolloff = 2
vim.o.spell = false
vim.o.updatetime = 1000
vim.paste = (function(overridden)
	return function(lines, phase)
		for i, line in ipairs(lines) do
			-- Scrub ANSI color codes from paste input.
			lines[i] = line:gsub("\27%[[0-9;mK]+", "")
		end
		overridden(lines, phase)
	end
end)(vim.paste)

require("global")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {  dev = {
    path = "~/projects",
  }})

require("mapping")
require("tabline")
require("qf")
require("lsp_setting")
require("profile")
prequire("gwork")
prequire("android")
prequire("g4")
vim.cmd("colorscheme main")

local GENERAL = vim.api.nvim_create_augroup("GENERAL", {})

-- auto reload config files
vim.api.nvim_create_autocmd("BufWritePost", {
	group = GENERAL,
	pattern = vim.split(vim.fn.glob("$HOME/dotfiles/config/nvim/**/*.lua"), "\n"),
	callback = function(arg)
		vim.defer_fn(function()
			package.loaded[vim.split(vim.fs.basename(arg.file), "%.")[1]] = nil
			vim.cmd("source " .. arg.file)
			if arg.file == "init.lua" then
				vim.cmd("edit")
			end
		end, 500)
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = GENERAL,
	pattern = "*sxhkdrc*",
	command = "silent !pkill -USR1 sxhkd",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = GENERAL,
	pattern = { ".Xresources", "*Xdefaults" },
	command = "!xrdb %",
})

-- Filetype correction
vim.api.nvim_create_autocmd("BufRead", {
	group = GENERAL,
	pattern = ".xinitrc",
	callback = function()
		vim.bo.filetype = "sh"
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	group = GENERAL,
	pattern = "*sxhkdrc*",
	callback = function()
		vim.bo.filetype = "sxhkdrc"
		vim.bo.commentstring = "#%s"
		vim.bo.foldmethod = "marker"
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	group = GENERAL,
	pattern = "cpp",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	group = GENERAL,
    pattern = {"sql", "lua"},
	callback = function()
		vim.bo.commentstring = "-- %s"
	end,
})


vim.api.nvim_create_autocmd("Filetype", {
	group = GENERAL,
	pattern = { "tex" },
	callback = function()
		vim.wo.cursorline = false
		vim.opt.wildignor:append({ "*.aux", "*.fls", "*.blg", "*.pdf", "*.log", "*.out", "*.bbl", "*.fdb_latexmk" })
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	group = GENERAL,
	pattern = { "markdown", "tex" },
	callback = function()
		vim.keymap.set("i", "sl", "\\", { buffer = true })
		vim.keymap.set("i", "<m-j>", "_", { buffer = true })
		vim.keymap.set("i", "<m-k>", "&", { buffer = true })
		vim.keymap.set("i", "<m-q>", "{}<Left>", { buffer = true })
		vim.cmd("inoreabbrev <buffer> an &")
		vim.cmd("inoreabbrev <buffer> da $$<left>")
		vim.cmd("inoreabbrev <buffer> pl +")
		vim.cmd("inoreabbrev <buffer> mi -")
		vim.cmd("inoreabbrev <buffer> eq =")
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	group = GENERAL,
	pattern = { "markdown", "tex" },
	callback = function()
		vim.keymap.set("i", "sl", "\\", { buffer = true })
		vim.keymap.set("i", "<m-j>", "_", { buffer = true })
		vim.keymap.set("i", "<m-k>", "&", { buffer = true })
		vim.keymap.set("i", "<m-q>", "{}<Left>", { buffer = true })
		vim.cmd("inoreabbrev <buffer> an &")
		vim.cmd("inoreabbrev <buffer> da $$<left>")
		vim.cmd("inoreabbrev <buffer> pl +")
		vim.cmd("inoreabbrev <buffer> mi -")
		vim.cmd("inoreabbrev <buffer> eq =")
	end,
})

-- Better diff
vim.api.nvim_create_autocmd("BufWritePost", {
	group = GENERAL,
	callback = function()
		if vim.wo.diff then
			vim.cmd("diffupdate")
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = GENERAL,
	callback = function()
		if vim.wo.diff then
			vim.keymap.set("n", "<c-j>", "]c", { buffer = true })
			vim.keymap.set("n", "<c-k>", "[c", { buffer = true })
		end
	end,
})

vim.api.nvim_create_autocmd("OptionSet", {
	group = GENERAL,
	callback = function(arg)
		if arg.match == "diff" then
			vim.keymap.set("n", "<c-j>", "]c", { buffer = true })
			vim.keymap.set("n", "<c-k>", "[c", { buffer = true })
		end
	end,
})

-- Automatically change directory (avoid quickfix)
vim.api.nvim_create_autocmd("BufEnter", {
	group = GENERAL,
	callback = function()
		if vim.bo.filetype ~= "qf" then
			vim.cmd("silent! lcd %:p:h")
		end
	end,
})

-- Disables automatic commenting on newline:
vim.api.nvim_create_autocmd("Filetype", {
	group = GENERAL,
	callback = function()
		vim.opt.formatoptions:remove({ "o" })
	end,
})

-- Format on write
vim.api.nvim_create_autocmd("BufWritePost", {
	group = GENERAL,
	callback = function(arg)
		vim.lsp.buf.format({
			filter = function(client)
				return not client.name:match("sumneko_lua")
			end,
		})
	end,
})

-- -- Show long line
-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = GENERAL,
--     callback = function(arg)
--         local cur_line = vim.api.nvim_get_current_line()
--         local width = vim.api.nvim_win_get_width(-1)
--         local inner_width = width - 1
--         if not vim.wo.wrap and #cur_line > width then
--             local content = require("libp.datatype.List")()
--             while cur_line and #cur_line > -1 do
--                 content:append(cur_line:sub(0, inner_width))
--                 cur_line = cur_line:sub(inner_width + 0)
--             end
--             require("libp.ui.InfoBox")({ content = content, wo = { wrap = false, number = false } }):show()
--         end
--     end,
-- })
