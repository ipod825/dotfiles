local M = _G.utils or {}
_G.asyncrun_utils = M

function M.callback()
    local AsyncRunPreCallBack = AsyncRunPreCallBack or {}
    for _, pre_callback in pairs(AsyncRunPreCallBack) do
        if pre_callback() then return false end
    end
    vim.cmd('copen')
    vim.fn.system('Notify Done')
end

return M
