local wk = require'which-key'
wk.setup{
    triggers = {
        { "<auto>", mode = "nixsotc" },
        { "m", mode = { "n", "v" } },
    }
}
wk.add{
    { "mg", group = 'git' },
    { 'mgn', "<cmd>exec 'lua require(\"gitsigns\").next_hunk({ preview = true })'<cr>", desc = 'Jump to next hunk' },
    { 'mgp', "<cmd>Gitsigns prev_hunk<cr>",                                 desc = 'Jump to previous hunk' },
    { 'mgP', "<cmd>Gitsigns preview_hunk<cr>",                              desc = 'Preview hunk' },
    { 'mgB', "<cmd>Git blame<cr>",                                          desc = 'Blame' },
    { 'mgf', "<cmd>Git fetch<cr>",                                          desc = 'Fetch' },
    { 'mgd', "<cmd>Gdiff<cr>",                                              desc = 'Diff' },
    { 'mgl', "<cmd>Telescope git_commits<cr>",                              desc = 'Log' },
    { 'mgb', "<cmd>Telescope git_branches<cr>",                             desc = 'Branches' },
    { 'mgL', "<cmd>Telescope git_bcommits<cr>",                             desc = 'Log of the file' },

    { "mp", "<cmd>Git pull<cr>",                                            desc = "Git Pull" },
    { "mP", "<cmd>Git push<cr>",                                            desc = "Git Push" },
    { "md", "<cmd>Trouble diagnostics toggle<cr>",                          desc = "Diagnostics" },
    { "mj", "<cmd>%!python3.12 -m json.tool<cr>",                           desc = "Pretty JSON" },
    { "mi", "<cmd>Telescope lsp_implementations<cr>",                       desc = "Implementation" },
    { "mf", '<cmd>exec "lua vim.lsp.buf.format()"<cr>',                     desc = 'Format the file' },
    { "mF", "<cmd>NvimTreeFindFile<cr>",                                    desc = "Open the current file in Tree" },
    { "ms", "<cmd>call CloseSidewins() | execute 'Git' | wincmd H | vertical resize 40 | setlocal winhl=Normal:NvimTreeNormal noequalalways<cr>", desc = 'Git status' },
    { 'mS', '<cmd>call CloseSidewins() | call OpenTODO()<cr>',              desc = 'Sketch Book' },
    { 'mr', '<cmd>exec "lua vim.lsp.buf.rename()"<cr>',                     desc = 'Rename' },
    { 'mt', '<cmd>!yarn prettier:fix<cr>',                                  desc = 'Prettier Fix' },
    { 'mw', '<cmd>setlocal wrap linebreak<cr>',                             desc = 'Wrap text in window' },
}
