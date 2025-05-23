local function lsp_on_attach(client, bufnr)
    -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec([[
            hi LspReferenceRead cterm=bold ctermbg=red guibg=#2c2c2c
            hi LspReferenceText cterm=bold ctermbg=red guibg=#2c2c2c
            hi LspReferenceWrite cterm=bold ctermbg=red guibg=#2c2c2c
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]], false)
    end

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            -- disable virtual text
            virtual_text = true,
            -- show signs
            signs = false,
        }
    )
end

local lspkind = require 'lspkind'
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = require 'cmp'
cmp.setup({
    view = {
        entries = "custom" -- can be "custom", "wildmenu" or "native"
    },
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = lspkind.cmp_format({ mode = 'symbol_text' }), -- can be 'text', 'text_symbol', 'symbol_text', 'symbol'
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        --- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp',                group_index = 0 },
        { name = 'nvim_lsp_signature_help' },
        -- { name = 'nvim_lsp_document_symbol' },
        { name = 'git' },
        { name = 'path' },
        -- { name = 'copilot', group_index = 2 },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup()
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = 'buffer' },
    })
})
cmp.setup.cmdline(':', {
    view = {
        entries = "wildmenu" -- can be "custom", "wildmenu" or "native"
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
cmp.setup.cmdline({ '/', '?' }, {
    view = {
        entries = "wildmenu" -- can be "custom", "wildmenu" or "native"
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local nvim_lsp = require('lspconfig')
local servers = { 'clangd', 'jsonls', 'ts_ls', 'gopls', 'bashls', 'terraformls',
                    'yamlls', 'jdtls', 'lua_ls', 'csharp_ls', 'pylsp' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = lsp_on_attach,
        capabilities = lsp_capabilities,
    }
end

-- Update diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
