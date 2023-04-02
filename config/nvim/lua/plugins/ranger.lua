return {
    "git@github.com:ipod825/ranger.nvim",
    config = function()
        local action = require("ranger.action")
        local profile = require("profile")
        local fs = require("libp.fs")
        local uv = require("libp.fs.uv")
        require("ranger").setup({
            hijack_netrw = true,
            rifle_path = require("libp.utils.pathfn").join(vim.fn.stdpath("config"), "settings/rifle.conf"),
            mappings = {
                n = {
                    ["<leader>f"] = function()
                        local _, node = action.utils.get_cur_buffer_and_node()
                        if node.abspath then
                            vim.fn["esearch#init"]({ paths = node.abspath, root_markers = {} })
                        else
                            vim.fn["esearch#init"]({ paths = vim.fn.getcwd(), root_markers = {} })
                        end
                    end,
                    i = function()
                        action.rename(profile.cur_env.ranger_rename_fn or uv.fs_rename)
                    end,
                    p = function()
                        action.transfer.paste({
                            copy_fn = function(...)
                                (profile.cur_env.ranger_copy_fn or fs.copy)(...)
                            end,
                            rename_fn = function(...)
                                (profile.cur_env.ranger_rename_fn or uv.fs_rename)(...)
                            end,
                        })
                    end,
                    yp = function()
                        action.transfer.copy_current()
                        action.transfer.paste({
                            copy_fn = function(ori_name)
                                (profile.cur_env.ranger_copy_fn or fs.copy)(ori_name, ori_name..'DUP')
                            end,
                        })
                    end,
                },
            },
        })
    end,
}
