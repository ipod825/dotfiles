local M = {
    root_markers = { ".git", ".hg", ".svn", ".bzr", "_darcs", ".root" },
    {
        "SmiteshP/nvim-navic",
        config = function()
            require("nvim-navic").setup()
        end,
    },
    { "Susensio/magic-bang.nvim", config = true },
    { "nvim-tree/nvim-web-devicons" },
    { "tridactyl/vim-tridactyl" },
    { "wsdjeg/vim-fetch" },
    { "farmergreg/vim-lastplace" },
    { "git@github.com:ipod825/vim-tabdrop" },
    { "RRethy/nvim-treesitter-endwise" },
    { "windwp/nvim-ts-autotag" },
    { "haringsrob/nvim_context_vt" },
    { "tpope/vim-abolish" },
    { "tami5/sqlite.lua" },
    { "jubnzv/virtual-types.nvim" },
    { "junegunn/fzf", build = ":call fzf#install()" },
    { "voldikss/vim-translator", cmd = "TranslateW" },
    { "onsails/lspkind.nvim" },
    { "ray-x/lsp_signature.nvim" },
    { "rhysd/vim-grammarous", cmd = "GrammarousCheck" },
    { "nvim-neotest/neotest" },
    { "neovim/nvim-lspconfig" },
    { "majutsushi/tagbar" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "machakann/vim-swap" },
    { "LukasPietzschmann/telescope-tabs" },
    { "will133/vim-dirdiff", cmd = "DirDiff" },
    { "mrjones2014/smart-splits.nvim" },
    { "whiteinge/diffconflicts" },
    { "git@github.com:ipod825/oldfiles.nvim", config = true },
    { "andymass/vim-matchup" },
    { "AndrewRadev/linediff.vim", cmd = { "LineDiffAdd" } },
    { "chrisbra/Colorizer" },
    { "ziontee113/color-picker.nvim" },
    { "rbtnn/vim-vimscript_lasterror" },
    { url = "sso://user/jackcogdill/nvim-figtree" },
    {url='sso://user/vvvv/ai.nvim'},
    { "mhinz/vim-signify" },
}

function M.reload(target)
    local function do_reload(t)
        local reloaded = false
        for name, _ in pairs(package.loaded) do
            if name:match(t) then
                package.loaded[name] = nil
                reloaded = true
            end
        end
        if reloaded then
            package.loaded.plugins = nil
            require("plugins")
        end
        return reloaded
    end

    return do_reload(target) or do_reload(target:gsub("^nvim-", ""))
end

return M
