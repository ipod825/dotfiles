function _G.prequire(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end

function _G.p(...)
	vim.print(...)
end


