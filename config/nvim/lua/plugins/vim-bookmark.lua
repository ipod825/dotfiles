return {
    "git@github.com:ipod825/vim-bookmark",
    cmd = { 'BookmarkGo', 'BookmarkAddPos' },
    init = function()
        vim.keymap.set("n", "'", "<cmd>BookmarkGo directory<cr>")
        vim.keymap.set("n", "m", "<cmd>BookmarkAddPos directory<cr>")
    end,
    config = function()
        vim.g.bookmark_opencmd = "NewTabdrop"
        vim.g.Bookmark_pos_context_fn = function()
            return {
                vim.fn["tagbar#currenttag"]("%s", "", "f"),
                vim.fn.getline("."),
            }
        end

        local BOOKMARK = vim.api.nvim_create_augroup("BOOKMARK", {})
        vim.api.nvim_create_autocmd("Filetype", {
            group = BOOKMARK,
            pattern = { "bookmark" },
            callback = function()
                vim.keymap.set("n", "<c-t>", function()
                    vim.fn["bookmark#open"]("Tabdrop")
                end, { buffer = 0 })
            end,
        })
    end,
}
