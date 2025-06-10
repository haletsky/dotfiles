require 'avante'.setup {
	provider = "ollama",
	ollama = {
		endpoint = "http://192.168.0.83:11434",
		model = "devstral",
	},
	windows = {
		wrap = true, -- similar to vim.o.wrap
		-- width = 30, -- default % based on available width
		position = "left",
		sidebar_header = {
			enabled = false,
			-- align = "center", -- left, center, right for title
			-- rounded = false,
		},
		ask = {
			start_insert = false, -- Start insert mode when opening the ask window
		},
	},
}
