local M = _G.utils or {}
_G.utils = M

function M.zip(...)
    local arrays, ans = {...}, {}
    local index = 0
    return function()
        index = index + 1
        for i, t in ipairs(arrays) do
            if type(t) == 'function' then
                ans[i] = t()
            else
                ans[i] = t[index]
            end
            if ans[i] == nil then return end
        end
        return unpack(ans)
    end
end

function M.list_unique(lst)
    local cache = {}
    local res = {}
    for _, e in pairs(lst) do
        if cache[e] == nil then
            table.insert(res, e)
            cache[e] = true
        end
    end
    return res
end

function M.pwd() return vim.fn.getcwd() end

function M.path_join(...) return table.concat({...}, '/') end

function M.dirname(str)
    local name = string.gsub(str, "(.*)/(.*)", "%1")
    return name
end

function M.basename(str)
    local name = string.gsub(str, "(.*/)(.*)", "%2")
    return name
end

function M.extension(str) return str:match('%.(.*)$') end

M.dirctory_register = M.dirctory_register or {}
function M.find_directory(anchor, name)
    local res = name and M.dirctory_register[name] or nil
    if res == nil then
        local dir = M.pwd()
        while #dir > 1 do
            if vim.fn.glob(M.path_join(dir, anchor)) ~= "" then
                res = dir
                break
            end
            dir = M.dirname(dir)
        end
        if name ~= nil then M.dirctory_register[name] = res end
    end
    return res
end

function M.left_tab_termopen(cmd)
    vim.cmd('tabedit | tabmove -1')
    vim.fn.termopen(cmd, {on_exit = function(_, _, _) vim.cmd('quit') end})
end

function M.collapse_white_space(str) return string.gsub(str, '%s+', ' ') end

function M.asyncrun_pre()
    vim.cmd('wincmd o')
    vim.g.asyncrun_win = vim.api.nvim_get_current_win()
end

function M.asyncrun_callback()
    vim.api.nvim_set_current_win(vim.g.asyncrun_win)
    if vim.g.asyncrun_code == 0 then
        vim.cmd('cclose')
    else
        vim.fn.setqflist(vim.tbl_filter(function(e) return e.valid ~= 0 end,
                                        vim.fn.getqflist()), 'r')
        vim.cmd('botright copen')
    end
    vim.fn.system([[zenity --info --text Done --display=$DISPLAY]])
end

return M
