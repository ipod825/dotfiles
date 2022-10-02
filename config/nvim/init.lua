function _G.prequire(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end

function _G.p(...)
	vim.pretty_print(...)
end

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
vim.o.spell = false
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
vim.o.cmdheight = 0

require("utils")
require("plugins")
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
		local map = vim.keymap.set
		map("i", "sl", "\\", { buffer = true })
		map("i", "<m-j>", "_", { buffer = true })
		map("i", "<m-k>", "&", { buffer = true })
		map("i", "<m-q>", "{}<Left>", { buffer = true })
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
		local map = vim.keymap.set
		map("i", "sl", "\\", { buffer = true })
		map("i", "<m-j>", "_", { buffer = true })
		map("i", "<m-k>", "&", { buffer = true })
		map("i", "<m-q>", "{}<Left>", { buffer = true })
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
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Format on write
vim.api.nvim_create_autocmd("BufWritePost", {
	group = GENERAL,
	callback = function(arg)
		if vim.bo.filetype ~= "lua" then
			vim.lsp.buf.format()
		end
	end,
})
