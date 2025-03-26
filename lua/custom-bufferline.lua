local bufferline = require("bufferline")
bufferline.setup({
    options = {
        style_preset = bufferline.style_preset.no_italic,
        themable = true,
        show_buffer_icons = false, -- disable filetype icons for buffers
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "slant",
        sort_by = function(bufa, bufb)
            return bufa.extension < bufb.extension
        end,
        diagnostics = "nvim_lsp",
        offsets = { {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
        }, {
            filetype = "fugitive",
            text = "GIT",
            text_align = "center",
        }, {
            filetype = "vimwiki",
            text = "Sketch Book",
            text_align = "center",
        }, {
            filetype = "fugitiveblame",
            text = "Git blame",
            text_align = "center",
        }, {
            filetype = "gitcommit",
            text = "GIT commit",
            text_align = "center",
        }, {
            filetype = "vim-plug",
            text = "VIM Plug",
            text_align = "center",
        } },
        custom_filter = function(buf, _)
            local arr = { 'vimwiki', 'fugitive', 'fugitiveblame', 'gitcommit', 'NvimTree' }
            for _, value in pairs(arr) do
                if vim.bo[buf].filetype == value then
                    return false
                end
            end

            local length = vim.fn.tabpagenr('$')
            local currenttab = vim.fn.tabpagenr()

            for i = 1, length, 1 do
                if i ~= currenttab then
                    for _, v in pairs(vim.fn.tabpagebuflist(i)) do
                        if v == buf then
                            return false
                        end
                    end
                end
            end

            return true
        end
    }
})
