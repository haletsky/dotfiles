require 'render-markdown'.setup {
	file_types = { "markdown", "Avante", "vimwiki" },
	code = {
		style = 'normal'
	},
}
vim.treesitter.language.register('markdown', 'vimwiki')
