local envrun = function(...)
    local args = { ... }
    return function()
        require("profile").run_handler(unpack(args))
    end
end

return {
    "folke/which-key.nvim",
    enabled = true,
    config = function()
        require("which-key").setup({
            triggers = { "<leader>" },
        })
        require("which-key").register({
            a = {
                "Abolish",
                c = { "<cmd>normal crc<cr>", "camelCase" },
                m = { "<cmd>normal crm<cr>", "MixedCase" },
                s = { "<cmd>normal crs<cr>", "snake_case" },
                u = { "<cmd>normal cru<cr>", "SNAKE_UPPERCASE" },
            },
            l = {
                name = "LSP",
                h = { vim.lsp.buf.hover, "Hover" },
                r = { vim.lsp.buf.references, "References" },
                i = { vim.lsp.buf.incoming_calls, "IncomingCalls" },
                o = { vim.lsp.buf.outgoing_calls, "OutgoingCalls" },
                R = { vim.lsp.buf.rename, "Rename" },
                a = { vim.lsp.buf.code_action, "CodeAction" },
                s = { vim.lsp.buf.signature_help, "SignatureHelp" },
            },
            r = {
                name = "Related files",
                t = {
                    envrun("OpenSrcOrTest"),
                    "Source or Test",
                },
                p = { envrun("OpenProducerOrGraph"), "Producer or Graph" },
            },
            t = {
                name = "telescope",
                b = {
                    function()
                        require("telescope.builtin").buffers({
                            previewer = false,
                            ignore_current_buffer = true,
                            sort_lastused = true,
                            sort_mru=true
                        })
                    end,
                    "Find Buffers",
                },
                y = { "<cmd>Telescope yank_history<cr>", "Yank History" },
                d = { "<cmd>Telescope diagnostics<cr>", "diagnostics" },
                o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
            },
            y = {
                name = "Copy",
                a = {
                    function()
                        local path = vim.fn.expand("%:p")
                        vim.fn.setreg("+", path)
                        vim.fn.setreg('"', path)
                    end,
                    "AbsPath",
                },
                b = {
                    function()
                        local path = vim.fn.expand("%:p:t")
                        vim.fn.setreg("+", path)
                        vim.fn.setreg('"', path)
                    end,
                    "Basename",
                },
                r = {
                    envrun("CopyEnvReview"),
                    "Review",
                },
                p = {
                    envrun("CopyEnvPath"),
                    "Path",
                },
                B = {
                    envrun("CopyEnvBinary"),
                    "Binary",
                },
                c = {
                    envrun("CopyEnvCodeSearch"),
                    "CodeSearch",
                },
                t = {
                    envrun("CopyEnvTarget"),
                    "Target",
                },
            },
        }, { prefix = "<leader>" })
    end,
}
