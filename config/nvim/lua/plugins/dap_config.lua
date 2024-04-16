local utils = require("utils")
local dap_ui = {
    "rcarriga/nvim-dap-ui",
    config = function()
        local dapui = require("dapui")
        local dap = require("dap")
        dapui.setup({
            layouts = {
                {
                    elements = {
                        "repl",
                    },
                    size = 0.01,
                    position = "top",
                },
                {
                    elements = {
                        "breakpoints",
                        "stacks",
                    },
                    size = 0.3,
                    position = "bottom",
                },
            },
            controls = {
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "↻",
                    terminate = "□",
                },
                enabled = true,
                element = "breakpoints",
            },
        })
        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
}

return {
    "mfussenegger/nvim-dap",
    dependencies = { dap_ui },
    enabled=false,
    config = function()
        _G.DapGetArgs = function(program, dap_run_co)
            program = program:gsub("/", "_")
            local dap_folder = vim.fn.stdpath("data") .. "/dap"
            vim.fn.mkdir(dap_folder, "p")
            local arg_file = ("%s/%s"):format(dap_folder, program)
            vim.cmd("split " .. arg_file)
            vim.cmd("silent! write")
            vim.bo.bufhidden = "wipe"
            vim.api.nvim_create_autocmd("Bufunload", {
                buffer = 0,
                once = true,
                callback = function()
                    coroutine.resume(
                        dap_run_co,
                        vim.tbl_filter(function(e)
                            return e and #e > 0
                        end, vim.fn.readfile(arg_file))
                    )
                end,
            })
        end
        local dap = require("dap")
        dap.adapters.python = {
            type = "executable",
            command = "python",
            args = { "-m", "debugpy.adapter" },
        }
        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    return "python"
                end,
            },
        }

        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "attach",
                host = function()
                    local value = vim.fn.input("Host [127.0.0.1]: ")
                    if value ~= "" then
                        return value
                    end
                    return "127.0.0.1"
                end,
                port = function()
                    local val = tonumber(vim.fn.input("Port: "))
                    assert(val, "Please provide a port number")
                    return val
                end,
            },
        }
        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host, port = config.port })
        end

        vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint" })
        vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DapBreakpointCondition" })
        vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpointRejected" })
        vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint" })
        vim.fn.sign_define("DapStopped", {
            text = " ",
            texthl = "DapStopped",
            linehl = "DapStoppedLine",
        })
        local color = require("colorscheme").color
        require("colorscheme").add_plug_hl({
            DapBreakpoint = { fg = color.red },
            DapBreakpointCondition = { fg = color.red },
            DapStopped = { fg = color.green },
            DapStoppedLine = { bg = color.base4 },
        })

        vim.api.nvim_create_user_command("Debug", function()
            local debug_mappings = {
                n = {
                    x = {
                        callback = function()
                            vim.cmd("DapStepOver")
                        end,
                    },
                    s = {
                        callback = function()
                            vim.cmd("DapStepInto")
                        end,
                    },
                    c = {
                        callback = function()
                            vim.cmd("DapContinue")
                        end,
                    },
                    E = {
                        callback = function()
                            require("dapui").eval(nil, { enter = true })
                        end,
                    },
                    B = {
                        callback = function()
                            vim.cmd("DapToggleBreakpoint")
                        end,
                    },
                },
                v = {
                    E = {
                        callback = function()
                            require("dapui").eval(nil, { enter = true })
                        end,
                    },
                },
            }

            local bufnr = vim.api.nvim_get_current_buf()
            local lnum = vim.api.nvim_win_get_cursor(0)[1]
            require("dap.breakpoints").remove(bufnr, lnum)
            vim.cmd("DapToggleBreakpoint")
            local original_mappings = utils.save_keymap(debug_mappings)
            utils.restore_keymap(debug_mappings.n, "n")
            utils.restore_keymap(debug_mappings.v, "v")
            vim.o.mouse = "a"
            vim.keymap.set("n", "T", function()
                utils.restore_keyvim.keymap.set(original_mappings)
                vim.keymap.del("n", "T")
                vim.o.mouse = ""
                pcall(require("dap").terminate)
            end)
            vim.cmd("DapContinue")
        end, { nargs = "?" })
    end,
}
