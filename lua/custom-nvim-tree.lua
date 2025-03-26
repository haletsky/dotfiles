require 'nvim-web-devicons'.setup {}
local nvimtree = require('nvim-tree')
nvimtree.setup({
    on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        -- vim.keymap.set('n', 'm', function()
        --     vim.cmd('WhichKey! g:which_key_map')
        -- end, opts('WhichKey'))
    end,
    git = {
        timeout = 2000,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = " ",
            info = " ",
            warning = " ",
            error = " ",
        },
    },
    view = {
        width = 40,
    },
    prefer_startup_root = true,
    hijack_unnamed_buffer_when_opening = true,
    actions = {
        use_system_clipboard = true,
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = false,
            }
        }
    },
    renderer = {
        icons = {
            show = {
                folder_arrow = false,
            },
            git_placement = "after",
            glyphs = {
                git = {
                    unstaged = "󱤇",
                    staged = "󱩺",
                    unmerged = "󰓻",
                    renamed = "󱜯",
                    untracked = "󱈤",
                    deleted = "󰤐",
                    ignored = "󰓼",
                },
            }
        },
        indent_markers = {
            enable = true,
        },
    },
})
