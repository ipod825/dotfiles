return {
    "eugen0329/vim-esearch",
    lazy=false,
    init = function()
        vim.g.esearch = {
            adapter = "rg",
            bckend = "nvim",
            out = "win",
            batch_size = 1000,
            default_mappings = 0,
            live_update = 1,
            win_ui_nvim_syntax = 1,
            root_markers = require("plugins").root_markers,
            remember = {
                "case",
                "regex",
                "filetypes",
                "before",
                "after",
                "context",
            },
            win_map = {
                { "n", "<cr>", '<cmd>call b:esearch.open("NewTabdrop")<cr>' },
                { "n", "t", '<cmd>call b:esearch.open("NETRTabdrop")<cr>' },
                {
                    "n",
                    "pp",
                    "<cmd>call b:esearch.split_preview_open() | wincmd W<cr>",
                },
                {
                    "n",
                    "R",
                    '<cmd>call b:esearch.reload({"backend": "system"})<cr>',
                },
            },
        }
    end,
    config = function()
        local ESEARCH = vim.api.nvim_create_augroup("ESEARCH", {})
        vim.api.nvim_create_autocmd("Filetype", {
            group = ESEARCH,
            pattern = "esearch",
            callback = function()
                vim.keymap.set("n", "yy", function()
                    vim.cmd("normal! yy")
                    vim.fn.setreg('"', vim.fn.getreg('"'):gsub("^%s*%d*%s*", ""))
                end)
            end,
        })
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = ESEARCH,
            command = "highlight! link esearchMatch Cursor",
        })
        vim.keymap.set("n", "<leader>f", "<Plug>(operator-esearch-prefill)iw", { remap = true })
        vim.keymap.set("x", "<leader>f", "<Plug>(esearch)", { remap = true })
        vim.keymap.set("n", "<leader>F", '<cmd>call esearch#init({"prefill":["cword"], "paths": expand("%:p")})<cr>')
        vim.keymap.set("x", "<leader>F", 'esearch#prefill({"paths": expand("%:p")})', { expr = true })
    end,
}
