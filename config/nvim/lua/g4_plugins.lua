local function add_util_menu(name, fn)
    require("fuzzy_menu").add_util_menu(name, fn, "g4")
end

local ts_codesearch = {
    url = "sso://user/vintharas/telescope-codesearch.nvim",
    config = function()
        require("telescope").load_extension("codesearch")
    end,
}

local cmp_cider_lsp = {
    url = "sso://googler@user/piloto/cmp-nvim-ciderlsp",
}

local google_comments = {
    url = "sso://user/chmnchiang/google-comments",
    config = function()
        require("google.comments").setup({ auto_fetch = false })
        local comments = require("google.comments")
        add_util_menu("ShowAllComments", comments.show_all_comments)
        -- g4.add_util_menu("ToggleLineComments", comments.toggle_line_comments)
        -- g4.add_util_menu("NextComment", comments.goto_next_comment)
        -- g4.add_util_menu("PrevComment", comments.goto_prev_comment)
    end,
}

return { ts_codesearch, cmp_cider_lsp, google_comments }
