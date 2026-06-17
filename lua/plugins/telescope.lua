return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep",
            "sharkdp/fd",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            local themes = require("telescope.themes")
            local zig_path = "C:/Zig/zig-x86_64-windows-0.15.1/lib/std"

            require("telescope").setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "case_sensitive",
                    },
                    ["ui-select"] = {
                        themes.get_dropdown({}),
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "fd", "--type", "f", "--case-sensitive", "--strip-cwd-prefix" },
                        case_mode = "case_sensitive",
                    }
                },
                defaults = {
                    mappings = {
                        i = {
                            ["<C-s>"] = actions.select_vertical,
                            ["<C-h>"] = actions.select_horizontal,
                        },
                        n = {
                            ["s"] = actions.select_vertical,
                            ["h"] = actions.select_horizontal,
                        },
                    },
                },
            })


            vim.keymap.set("n", "<leader>ff", function()
                builtin.find_files {
                    file_ignore_patterns = {"%.uid", "%.import", "%.tmp", "%.png", "%.ogg", "%.wav"},
                }
            end
            )

            -- search for scripts
            vim.keymap.set("n", "<leader>fs", function()
                builtin.find_files {
                    file_ignore_patterns = {"%.uid", "%.tscn", "%.import", "%.tres", "%.tmp", "%.png", "%.wav", "%.ogg", "%.res"},
                }
            end
            )

            -- search in zig std
            vim.keymap.set("n", "<leader>fz", function()
                builtin.find_files {
                    cwd = zig_path
                }
            end
            )

            -- Search for nvim config
            vim.keymap.set("n", "<leader>fv", function()
                builtin.find_files {
                    cwd = vim.fn.stdpath("config")
                }
            end
            )

            -- Search in the nvim lua plugins source code
            vim.keymap.set("n", "<leader>fp", function()
                builtin.find_files {
                    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
                }
            end
            )

            -- Live grep in files
            vim.keymap.set("n", "<leader>gg", function()
                builtin.live_grep {
                    file_ignore_patterns = {"%.uid", "%.import", "%.tmp"},
                    additional_args = function()
                        return { "--case-sensitive" }  -- or "--ignore-case"
                    end,
                }
            end
            )

            -- Live grep in scripts
            vim.keymap.set("n", "<leader>gs", function()
                builtin.live_grep {
                    file_ignore_patterns = {"%.uid", "%.tscn", "%.import", "%.tres", "%.tmp"},
                }
            end
            )

            -- Live grep current word in scripts
            vim.keymap.set("n", "<leader>ggs", function()
                builtin.grep_string {
                    file_ignore_patterns = {"%.uid", "%.tscn", "%.import", "%.tres", "%.tmp"},
                }
            end
            )

            -- Live grep in zig std files
            vim.keymap.set("n", "<leader>gz", function()
                builtin.live_grep {
                    cwd = zig_path
                }
            end
            )

            -- Live grep in config files
            vim.keymap.set("n", "<leader>gc", function()
                builtin.live_grep {
                    cwd = vim.fn.stdpath("config")
                }
            end
            )

            -- Live grep nvim lua plugins source code
            vim.keymap.set("n", "<leader>gp", function()
                builtin.live_grep {
                    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
                }
            end
            )

            -- Browse for functions using the lsp
            vim.keymap.set("n", "<leader>fn", function()
                builtin.lsp_document_symbols({ symbols = { "function", "method"} })
            end
            )

            -- Browse for functions using the lsp
            vim.keymap.set("n", "<leader>fc", function()
                builtin.lsp_document_symbols({ symbols = "Constant" })
            end, { desc = "Fuzzy find all constant declarations" }
            )

            require("telescope").load_extension("ui-select")
        end,
    },
}
