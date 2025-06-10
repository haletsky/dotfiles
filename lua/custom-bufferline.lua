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
			local bufa_type = bufa.buftype
			local bufb_type = bufb.buftype

			-- If “bufa” is a terminal and “bufb” is not, put bufa first
			if bufa_type == "terminal" and bufb_type ~= "terminal" then
				return true
			end
			-- If “bufb” is a terminal and “bufa” is not, put bufb first
			if bufb_type == "terminal" and bufa_type ~= "terminal" then
				return false
			end

			-- Otherwise, fall back to your old “extension” sort
			return bufa.extension < bufb.extension
		end,

		diagnostics = "nvim_lsp",
		offsets = { {
			filetype = "NvimTree",
			text = "󰙅 File Explorer",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "fugitive",
			text = " Repository",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "vimwiki",
			text = "  Sketch Book",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "fugitiveblame",
			text = " Git blame",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "gitcommit",
			text = " Git commit",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "vim-plug",
			text = "󰏔 Vim Plug",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "Avante",
			text = "󰭹 Avante",
			highlight = "BufferLineTitle",
			text_align = "center",
		}, {
			filetype = "AvanteInput",
			text = "󰭹 Avante",
			highlight = "BufferLineTitle",
			text_align = "center",
		} },
		custom_filter = function(buf, _)
			local arr = { 'vimwiki', 'fugitive', 'fugitiveblame', 'gitcommit', 'NvimTree', 'Avante' }
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
