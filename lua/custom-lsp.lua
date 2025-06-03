-- Define diagnostic signs and default diagnostic settings
local function setup_diagnostics()
	vim.diagnostic.config({
		-- virtual_text = true,
		virtual_lines = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = ' ',
				[vim.diagnostic.severity.WARN] = ' ',
				[vim.diagnostic.severity.HINT] = ' ',
				[vim.diagnostic.severity.INFO] = ' ',
			},
		},
		underline = true,
		update_in_insert = false,
		float = {
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
		},
	})
end

-- Configure handlers, highlights, and autocmds once
local function setup_lsp_highlights_and_autocmds(bufnr, client)
	-- If server supports documentHighlight, set up highlights & autocmds
	if client.server_capabilities.documentHighlightProvider then
		-- Define highlight groups
		-- vim.api.nvim_set_hl(0, "LspReferenceRead", { cterm = bold, ctermbg = "red", bg = "#2c2c2c" })
		-- vim.api.nvim_set_hl(0, "LspReferenceText", { cterm = bold, ctermbg = "red", bg = "#2c2c2c" })
		-- vim.api.nvim_set_hl(0, "LspReferenceWrite", { cterm = bold, ctermbg = "red", bg = "#2c2c2c" })

		-- Create a buffer-local augroup
		local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	-- Auto-format on save (for any LSP-attached buffer)
	local fmt_group = vim.api.nvim_create_augroup("LspAutoFormat", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = fmt_group,
		buffer = bufnr,
		callback = function()
			-- Use client ID to avoid conflicts if multiple LSPs are attached
			vim.lsp.buf.format({ async = false, id = client.id, bufnr = bufnr })
		end,
	})
end

-- on_attach: invoked by each LSP server when it attaches to a buffer
local function lsp_on_attach(client, bufnr)
	setup_lsp_highlights_and_autocmds(bufnr, client)

	-- Example keymaps (uncomment / edit to your liking)
	-- local opts = { noremap = true, silent = true }
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- …etc…
end

-- Setup cmp (completion) with lspkind and other sources
local function setup_cmp()
	local cmp_ok, cmp = pcall(require, "cmp")
	if not cmp_ok then
		vim.notify("nvim-cmp not installed", vim.log.levels.WARN)
		return
	end

	local lspkind_ok, lspkind = pcall(require, "lspkind")
	if not lspkind_ok then
		vim.notify("lspkind not installed", vim.log.levels.WARN)
	end

	-- Get default capabilities and enhance with nvim-cmp
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local cmp_nvim_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if cmp_nvim_lsp_ok then
		capabilities = cmp_lsp.default_capabilities(capabilities)
	end

	cmp.setup({
		preselect = cmp.PreselectMode.None,
		view = { entries = "custom" },
		formatting = {
			format = lspkind_ok
				and lspkind.cmp_format({ mode = "symbol_text" })
				or nil,
		},
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		window = {
			completion    = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"]     = cmp.mapping.scroll_docs(-4),
			["<C-f>"]     = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"]     = cmp.mapping.abort(),
			["<Tab>"]     = cmp.mapping(function(fallback)
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
			["<S-Tab>"]   = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif vim.fn["vsnip#jumpable"](-1) == 1 then
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, false, true),
						"",
						true
					)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp",               group_index = 0 },
			{ name = "nvim_lsp_signature_help" },
			{ name = "git" },
			{ name = "path" },
		}, {
			{ name = "buffer" },
		}),
	})

	-- Git commit messages
	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }),
	})

	-- Command-line completion for “:” and search
	cmp.setup.cmdline(":", {
		view = { entries = "wildmenu" },
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	})
	cmp.setup.cmdline({ "/", "?" }, {
		view = { entries = "wildmenu" },
		mapping = cmp.mapping.preset.cmdline(),
		sources = { { name = "buffer" } },
	})

	-- If you installed cmp-git
	local ok_git, cmp_git = pcall(require, "cmp_git")
	if ok_git then
		cmp_git.setup()
	end

	return capabilities
end

-- 1) Diagnostics (signs, virtual text, floating, etc.)
setup_diagnostics()

-- 2) CMP: return enhanced capabilities
local capabilities = setup_cmp()

-- 3) LSP servers
local lspconfig = require("lspconfig")

local servers = {
	"clangd",
	"jsonls",
	"ts_ls",
	"gopls",
	"bashls",
	"terraformls",
	"yamlls",
	"jdtls",
	"lua_ls",
	"csharp_ls",
	"pylsp",
}
for _, name in ipairs(servers) do
	lspconfig[name].setup({
		on_attach    = lsp_on_attach,
		capabilities = capabilities,
	})
end
