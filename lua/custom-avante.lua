require 'avante'.setup {
	provider = "ollama",
	providers = {
		ollama = {
			endpoint = "http://192.168.0.83:11434",
			model = "qwen3-coder:30b-a3b-q4_K_M",
		},
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
