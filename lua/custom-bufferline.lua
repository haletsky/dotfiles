require("bufferline").setup({
    options = {
        separator_style = "slant",
        sort_by = function(bufa, bufb)
            return bufa.extension < bufb.extension
        end,
        diagnostics = "nvim_lsp",
        offsets = { {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center"
        }, {
            filetype = "fugitive",
            text = "GIT",
            text_align = "center"
        }, {
            filetype = "vimwiki",
            text = "Sketch Book",
            text_align = "center"
        }, {
            filetype = "fugitiveblame",
            text = "Git blame",
            text_align = "center"
        }, {
            filetype = "gitcommit",
            text = "GIT commit",
            text_align = "center"
        }, {
            filetype = "vim-plug",
            text = "VIM Plug",
            text_align = "center"
        } },
        custom_filter = function(buf, _)
            if vim.bo[buf].filetype == 'vimwiki' then return false end
            if vim.bo[buf].filetype == 'fugitive' then return false end
            if vim.bo[buf].filetype == 'gitcommit' then return false end

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
