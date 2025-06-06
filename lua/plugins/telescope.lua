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

            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        themes.get_dropdown({}),
                    },
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

            -- search for files
            vim.keymap.set("n", "<leader>ff", function()
                builtin.find_files {
                    file_ignore_patterns = {"%.uid", "%.import", "%.tmp"}
                }
            end
            )

            -- search for scripts
            vim.keymap.set("n", "<leader>fs", function()
                builtin.find_files {
                    file_ignore_patterns = {"%.uid", "%.tscn", "%.import", "%.tres", "%.tmp"},
                }
            end
            )

            -- Search for nvim config
            vim.keymap.set("n", "<leader>fc", function()
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
                    file_ignore_patterns = {"%.uid", "%.import", "%.tmp"}
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

            require("telescope").load_extension("ui-select")
        end,
    },
}
