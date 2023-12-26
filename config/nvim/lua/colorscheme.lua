local M = {}

M.color = {
	base0 = "#1B2229",
	base1 = "#1c1f24",
	base2 = "#202328",
	base3 = "#23272e",
	base4 = "#3f444a",
	base5 = "#5B6268",
	base6 = "#73797e",
	base7 = "#9ca0a4",
	base8 = "#b1b1b1",

	bg = "#282a36",
	bg1 = "#504945",
	bg_popup = "#3E4556",
	bg_highlight = "#2E323C",
	bg_visual = "#b3deef",

	fg = "#bbc2cf",
	fg_alt = "#5B6268",

	red = "#e95678",

	redwine = "#d16d9e",
	orange = "#D98E48",
	yellow = "#f0c674",

	light_green = "#abcf84",
	green = "#afd700",
	dark_green = "#98be65",

	cyan = "#36d0e0",
	blue = "#61afef",
	violet = "#b294bb",
	magenta = "#c678dd",
	teal = "#1abc9c",
	grey = "#928374",
	brown = "#c78665",
	black = "#000000",

	bracket = "#80A0C2",
	currsor_bg = "#4f5b66",
	none = "NONE",
}

function M.terminal_color(color)
	color = vim.tbl_extend("keep", color or {}, M.color)
	vim.g.terminal_color_0 = color.bg
	vim.g.terminal_color_1 = color.red
	vim.g.terminal_color_2 = color.green
	vim.g.terminal_color_3 = color.yellow
	vim.g.terminal_color_4 = color.blue
	vim.g.terminal_color_5 = color.violet
	vim.g.terminal_color_6 = color.cyan
	vim.g.terminal_color_7 = color.bg1
	vim.g.terminal_color_8 = color.brown
	vim.g.terminal_color_9 = color.red
	vim.g.terminal_color_10 = color.green
	vim.g.terminal_color_11 = color.yellow
	vim.g.terminal_color_12 = color.blue
	vim.g.terminal_color_13 = color.violet
	vim.g.terminal_color_14 = color.cyan
	vim.g.terminal_color_15 = color.fg
end

function M.highlight(group, def)
	local style = def.style or "NONE"
	local fg = def.fg or "NONE"
	local bg = def.bg or "NONE"
	local sp = def.sp and "guisp=" .. def.sp or ""
	vim.api.nvim_command(string.format("highlight %s gui=%s guifg=%s guibg=%s %s", group, style, fg, bg, sp))
end

function M.builtin_hl_def(color)
	color = vim.tbl_extend("keep", color or {}, M.color)
	return {
		Normal = { fg = color.fg, bg = color.bg },
		Terminal = { fg = color.fg, bg = color.bg },
		SignColumn = { fg = color.fg, bg = color.bg },
		FoldColumn = { fg = color.fg_alt, bg = color.black },
		VertSplit = { fg = color.orange, bg = color.bg },
		WinSeparator = {default=true, link='Label'},
		Folded = { fg = color.grey, bg = color.bg_highlight },
		EndOfBuffer = { fg = color.bg, bg = color.none },
		IncSearch = { fg = color.bg1, bg = color.orange },
		Search = { fg = color.bg, bg = color.orange },
		ColorColumn = { fg = color.none, bg = color.bg_highlight },
		Conceal = { fg = color.grey, bg = color.none },
		Cursor = { fg = color.none, bg = color.none, reverse = true },
		vCursor = { fg = color.none, bg = color.none, reverse = true },
		iCursor = { fg = color.none, bg = color.none, reverse = true },
		lCursor = { fg = color.none, bg = color.none, reverse = true },
		CursorIM = { fg = color.none, bg = color.none, reverse = true },
		CursorColumn = { fg = color.none, bg = color.bg_highlight },
		CursorLine = { fg = color.none, bg = color.bg_highlight },
		LineNr = { fg = color.base6 },
		qfLineNr = { fg = color.cyan },
		CursorLineNr = { fg = color.blue },
		DiffAdd = { fg = color.normal, bg = color.fg_alt },
		DiffChange = { fg = color.none, bg = color.fg_alt },
		DiffDelete = { fg = color.redwine, bg = color.none },
		DiffText = { fg = color.black, bg = color.dark_green },
		Directory = { fg = color.blue, bg = color.none },
		ErrorMsg = { fg = color.red, bg = color.none, bold = true },
		WarningMsg = { fg = color.yellow, bg = color.none, bold = true },
		ModeMsg = { fg = color.fg, bg = color.none, bold = true },
		MatchParen = { fg = color.red, bg = color.none, reverse = true },
		NonText = { fg = color.bg1 },
		Whitespace = { fg = color.base4 },
		SpecialKey = { fg = color.bg1 },
		Pmenu = { fg = color.fg, bg = color.bg_popup },
		PmenuSel = { fg = color.base0, bg = color.blue },
		PmenuSelBold = { fg = color.base0, bg = color.blue },
		PmenuSbar = { fg = color.none, bg = color.base4 },
		PmenuThumb = { fg = color.violet, bg = color.light_green },
		WildMenu = { fg = color.fg, bg = color.green },
		Question = { fg = color.yellow },
		NormalFloat = { fg = color.none, bg = color.base4 },
		Tabline = { fg = color.base5, bg = color.bg },
		TabLineSel = { fg = color.base8, bg = color.bg1, bold = true, italic = true },
		TabLineFill = {},
		TabLineSelMod = { fg = color.bg, bg = color.redwine, bold = true, italic = true },
		TabLineMod = { fg = color.redwine, bg = color.bg },
		StatusLine = { fg = color.base8, bg = color.base2 },
		StatusLineNC = { fg = color.grey, bg = color.base2 },
		SpellBad = { fg = color.red, bg = color.none, undercurl = true },
		SpellCap = { fg = color.blue, bg = color.none, undercurl = true },
		SpellLocal = { fg = color.cyan, bg = color.none, undercurl = true },
		SpellRare = { fg = color.violet, bg = color.none, undercurl = true },
		Visual = { fg = color.black, bg = color.bg_visual },
		VisualNOS = { fg = color.black, bg = color.bg_visual },
		QuickFixLine = { fg = color.violet, bold = true },
		Debug = { fg = color.orange },
		debugBreakpoint = { fg = color.bg, bg = color.red },

		Boolean = { fg = color.orange },
		Number = { fg = color.brown },
		Float = { fg = color.brown },
		PreProc = { fg = color.violet },
		PreCondit = { fg = color.violet },
		Include = { fg = color.violet },
		Define = { fg = color.violet },
		Conditional = { fg = color.magenta },
		Repeat = { fg = color.magenta },
		Keyword = { fg = color.green },
		Typedef = { fg = color.red },
		Exception = { fg = color.red },
		Statement = { fg = color.red },
		Error = { fg = color.red },
		StorageClass = { fg = color.orange },
		Tag = { fg = color.orange },
		Label = { fg = color.orange },
		Structure = { fg = color.orange },
		Operator = { fg = color.redwine },
		Title = { fg = color.orange, bold = true },
		Special = { fg = color.yellow },
		SpecialChar = { fg = color.yellow },
		Type = { fg = color.teal },
		Function = { fg = color.yellow },
		String = { fg = color.light_green },
		Character = { fg = color.green },
		Constant = { fg = color.cyan },
		Macro = { fg = color.cyan },
		Identifier = { fg = color.blue },

		Comment = { fg = color.base6 },
		SpecialComment = { fg = color.grey },
		Todo = { fg = color.violet },
		Delimiter = { fg = color.fg },
		Ignore = { fg = color.grey },
		Underlined = { fg = color.none, underline = true },
	}
end

M.plugin_hl_def = {}
function M.add_plug_hl(hls)
	if vim.tbl_islist(hls) then
		for _, name in ipairs(hls) do
			M.plugin_hl_def[name] = M.plugin_hl_def[name] or false
		end
	else
		for name, def in pairs(hls) do
			M.plugin_hl_def[name] = def
		end
	end
end

function M.load(color)
	vim.api.nvim_command("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.api.nvim_command("syntax reset")
	end
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.g.colors_name = "main"
	for group, colors in pairs(M.builtin_hl_def(color)) do
		vim.api.nvim_set_hl(0, group, colors)
	end
	for group, colors in pairs(M.plugin_hl_def) do
		if not colors then
			vim.defer_fn(function()
				M.plugin_hl_def[group] = vim.api.nvim_get_hl_by_name(group, 0)
				vim.api.nvim_set_hl(0, group, M.plugin_hl_def[group])
			end, 10)
		else
			vim.api.nvim_set_hl(0, group, colors)
		end
	end
end

return M
