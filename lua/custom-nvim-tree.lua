require 'nvim-web-devicons'.setup {}
require('nvim-tree').setup({
    on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', 'm', function()
            vim.cmd('WhichKey! g:which_key_map')
        end, opts('WhichKey'))
    end,
    diagnostics = {
        enable = true,
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
            }
        },
        indent_markers = {
            enable = true,
        },
    },
})
