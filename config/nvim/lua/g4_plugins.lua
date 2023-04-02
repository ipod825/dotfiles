local ts_codesearch = {
    url = "sso://user/vintharas/telescope-codesearch.nvim",
    config = function()
        require("telescope").load_extension("codesearch")
    end,
}

local cmp_cider_lsp = {
    url = "sso://googler@user/piloto/cmp-nvim-ciderlsp",
}

return { ts_codesearch, cmp_cider_lsp }
