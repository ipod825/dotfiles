local M = _G.utils or {}
_G.utils = M

M.util_fns = M.util_fns or {default = {}}
function M.add_util_menu(name, fn, id)
    id = id or 'default'
    if M.util_fns[id] == nil then M.util_fns[id] = {} end
    if M.util_fns[id][name] == nil then M.util_fns[id][name] = fn end
end

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

return M
