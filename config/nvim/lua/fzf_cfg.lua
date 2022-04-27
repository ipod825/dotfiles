local M = _G.fzf_cfg or {}
_G.fzf_cfg = M
local map = vim.keymap.set

vim.g.fzf_layout = { window = { width = 1, height = 1 } }
vim.g.fzf_action = {
	["ctrl-e"] = "edit",
	["Enter"] = "Tabdrop",
	["ctrl-s"] = "split",
	["ctrl-v"] = "vsplit",
}
vim.g.fzf_ft = ""
vim.api.nvim_exec(
	[[
augroup FZF
    autocmd!
    autocmd! FileType fzf if strlen(g:fzf_ft)  && g:fzf_ft!= "man" | silent! let &ft=g:fzf_ft | endif
    autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
    autocmd VimEnter * command! -bang -nargs=? Buffers call fzf#vim#buffers(<q-args>, {'options': '--no-preview'}, <bang>0)
augroup END
]],
	false
)

function M.fzf(source, sink, options)
	if sink ~= nil then
		local fzf_opts_wrap = vim.fn["fzf#wrap"]({ source = source, options = options })
		-- 'sink*' needs to be defined outside wrap()
		fzf_opts_wrap["sink*"] = function(l)
			sink(l[2])
		end
		vim.fn["fzf#run"](fzf_opts_wrap)
	else
		-- fzf's default handler is written in vim script (an s: function),
		-- currently it's translated into nil. This is a WAR by calling fzf#wrap
		-- in vimscript in vim.
		local source_str = string.format('["%s"]', table.concat(source, '","'))
		if options ~= nil then
			local options_str = table.concat(options, ",")
			vim.cmd(string.format([[call fzf#run(fzf#wrap({'source':%s, 'options':%s}))]], source_str, options_str))
		else
			vim.cmd(string.format([[call fzf#run(fzf#wrap({'source':%s}))]], source_str))
		end
	end
end

return M
