local M = _G.tabline or {}
_G.tabline = M
local api = vim.api
local utils = require 'utils'

api.nvim_exec([[
augroup TABLINE
    autocmd!
    autocmd ColorScheme * hi TabLineSel gui=bold,italic guifg=#bbc2cf guibg=#282a36
    autocmd ColorScheme * hi TabLine guifg=#73797e guibg=#1e1f28 
augroup END
]], false)

M.small_numbers = {
    ["0"] = "⁰",
    ["1"] = "¹",
    ["2"] = "²",
    ["3"] = "³",
    ["4"] = "⁴",
    ["5"] = "⁵",
    ["6"] = "⁶",
    ["7"] = "⁷",
    ["8"] = "⁸",
    ["9"] = "⁹"
}
function M.unicode_num(number)
    local res = ""
    local number_str = string.format('%d', number)
    for i = 1, #number_str do
        res = res .. M.small_numbers[number_str:sub(i, i)]
    end
    return res
end

function M.tab_label(tab_id, current_tab_id)
    local win_id = api.nvim_tabpage_get_win(tab_id)
    local buf_id = api.nvim_win_get_buf(win_id)
    local name = utils.basename(api.nvim_buf_get_name(buf_id))
    local filetype = api.nvim_buf_get_option(buf_id, 'ft')

    -- local content = string.format(' %s ', name)
    local content = string.format('%s', name)
    local current_tab_nr = api.nvim_tabpage_get_number(current_tab_id)
    local tab_nr = api.nvim_tabpage_get_number(tab_id)
    local is_current = (tab_id == current_tab_id)
    local is_left_to_current = (tab_nr == current_tab_nr - 1)
    return {
        highlight = is_current and 'TabLineSel' or 'TabLine',
        elements = {
            {highlight = 'Directory', content = is_current and '|' or ''},
            {
                highlight = 'Directory',
                content = filetype == 'netranger' and '' or ''
            }, {content = content},
            {highlight = 'NonText', content = is_left_to_current and '' or '|'}
        }
    }
end

function M.plain_length(label)
    local res = 0
    for _, e in pairs(label.elements) do
        res = res + vim.fn.strwidth(e.content)
    end
    return res
end

function M.filter(labels)
    local width = vim.o.columns

    local current_nr = api.nvim_tabpage_get_number(
                           api.nvim_get_current_tabpage())
    local left_nr = current_nr
    local right_nr = current_nr
    local total_length = M.plain_length(labels[current_nr])

    while true do
        local l = left_nr - 1
        local r = right_nr + 1
        local l_length = l > 0 and M.plain_length(labels[l]) or 0
        local r_length = r <= #labels and M.plain_length(labels[r]) or 0
        total_length = total_length + l_length + r_length
        left_nr = l > 0 and l or left_nr
        right_nr = r <= #labels and r or right_nr
        if total_length >= width or (left_nr == 1 and right_nr == #labels) then
            break
        end
    end

    return vim.list_slice(labels, left_nr, right_nr), total_length, left_nr > 1,
           right_nr < #labels
end

function M.reduce_from_right(total_length, width, labels)
    local target_reduce = total_length - width
    local l = #labels
    while target_reduce > 0 and l > 1 do
        local last_label = labels[l]
        local i = #last_label.elements
        while i > 0 do
            local c = last_label.elements[i].content
            -- todo: handle unicode substr
            last_label.elements[i].content =
                c:sub(1, math.max(#c - target_reduce, 0))
            target_reduce = target_reduce - math.min(#c, target_reduce)
            i = i - 1
        end
        l = l - 1
    end
end

function M.reduce_from_left(total_length, width, labels)
    local target_reduce = total_length - width
    local l = 1
    while target_reduce > 0 and l < #labels do
        local first_label = labels[l]
        local i = 1

        while i <= #first_label.elements do
            local c = first_label.elements[i].content
            -- todo: handle unicode substr
            first_label.elements[i].content = c:sub(target_reduce + 1)
            target_reduce = target_reduce - math.min(#c, target_reduce)
            i = i + 1
        end
        l = l + 1
    end
end

function M.gen_tab_line(labels, total_length, left_has_more, right_has_more)
    local left_more_indicator = left_has_more and '' or ''
    local right_more_indicator = right_has_more and '' or ''
    local width = vim.o.columns - vim.fn.strwidth(left_more_indicator) -
                      vim.fn.strwidth(right_more_indicator)

    if total_length > width then
        if not right_has_more then
            M.reduce_from_left(total_length, width, labels)
        else
            M.reduce_from_right(total_length, width, labels)
        end
    end

    local res = ''
    for _, label in pairs(labels) do
        for _, element in pairs(label.elements) do
            res = res ..
                      string.format('%%#%s#%s',
                                    element.highlight or label.highlight,
                                    element.content)
        end
    end
    return string.format('%%#DiffDelete#%s%s%%#DiffDelete#%s%%#TabLine#',
                         left_more_indicator, res, right_more_indicator)
end

function M.tabline()
    local labels = {}
    local total_length, left_has_more, right_has_more

    local current_tab_id = api.nvim_get_current_tabpage()
    for _, tab_id in pairs(api.nvim_list_tabpages()) do
        table.insert(labels, M.tab_label(tab_id, current_tab_id))
    end

    labels, total_length, left_has_more, right_has_more = M.filter(labels)
    return M.gen_tab_line(labels, total_length, left_has_more, right_has_more)
end

vim.o.tabline = '%!v:lua.tabline.tabline()'
return M
