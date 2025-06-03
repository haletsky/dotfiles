require 'avante'.setup {
	provider = "ollama",
	ollama = {
		endpoint = "http://192.168.0.83:11434",
		model = "devstral",
	},
	windows = {
		wrap = true,         -- similar to vim.o.wrap
		width = 30,          -- default % based on available width
		sidebar_header = {
			align = "right", -- left, center, right for title
			rounded = false,
		},
	},
}
