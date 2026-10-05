-- Start native highlighting whenever a parser and highlight queries are installed.
-- Resolve filetype aliases too (e.g. typescriptreact, sh, help, and vimwiki).
local group = vim.api.nvim_create_augroup('CodeTreesitter', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
	group = group,
	desc = 'Enable Tree-sitter for installed parsers',
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if not lang then
			return
		end

		local parser_ok, installed = pcall(vim.treesitter.language.add, lang)
		if not parser_ok then
			vim.notify_once('Tree-sitter parser unavailable: ' .. tostring(installed), vim.log.levels.WARN)
			return
		end
		if not installed then
			-- Filetypes without an installed parser keep their regular syntax settings.
			return
		end

		local query_ok, highlights = pcall(vim.treesitter.query.get, lang, 'highlights')
		if not query_ok then
			vim.notify_once('Tree-sitter highlight queries unavailable: ' .. tostring(highlights), vim.log.levels.WARN)
			return
		end
		if not highlights then
			return
		end

		local highlighter = vim.treesitter.highlighter.active[args.buf]
		if not highlighter or highlighter.tree:lang() ~= lang then
			local ok, err = pcall(vim.treesitter.start, args.buf, lang)
			if not ok then
				vim.notify_once('Tree-sitter highlighting unavailable: ' .. tostring(err), vim.log.levels.WARN)
				return
			end
		end
		vim.bo[args.buf].syntax = ''

		-- Use native folds in file buffers without changing help/plugin window settings.
		if vim.bo[args.buf].buftype == '' then
			for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
				vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				vim.wo[win].foldmethod = 'expr'
			end
		end
	end,
})

if vim.fn.has('nvim-0.12') == 0 then
	return
end

local ok, _ = pcall(require, 'nvim-treesitter.query_predicates')
if not ok then
	return
end

local query = require('vim.treesitter.query')

local html_script_type_languages = {
	["importmap"] = "json",
	["module"] = "javascript",
	["application/ecmascript"] = "javascript",
	["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
	ex = "elixir",
	pl = "perl",
	sh = "bash",
	uxn = "uxntal",
	ts = "typescript",
}

local function get_parser_from_markdown_info_string(injection_alias)
	local match = vim.filetype.match({ filename = "a." .. injection_alias })
	return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

local function valid_args(name, pred, count, strict_count)
	local arg_count = #pred - 1

	if strict_count then
		if arg_count ~= count then
			vim.api.nvim_err_writeln(string.format("%s must have exactly %d arguments", name, count))
			return false
		end
	elseif arg_count < count then
		vim.api.nvim_err_writeln(string.format("%s must have at least %d arguments", name, count))
		return false
	end

	return true
end

-- Neovim 0.12 passes capture tables as `capture_id -> TSNode[]`.
-- nvim-treesitter still assumes single nodes in a few custom handlers.
local function capture_node(match, capture_id)
	local capture = match[capture_id]
	if capture == nil then
		return nil
	end
	if type(capture) == "table" then
		return capture[1]
	end
	return capture
end

query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
	if not valid_args("nth?", pred, 2, true) then
		return
	end

	local node = capture_node(match, pred[2])
	local n = tonumber(pred[3])
	if node and node:parent() and node:parent():named_child_count() > n then
		return node:parent():named_child(n) == node
	end

	return false
end, { force = true })

query.add_predicate("is?", function(match, _pattern, bufnr, pred)
	if not valid_args("is?", pred, 2) then
		return
	end

	local locals = require('nvim-treesitter.locals')
	local node = capture_node(match, pred[2])
	local types = { unpack(pred, 3) }

	if not node then
		return true
	end

	local _, _, kind = locals.find_definition(node, bufnr)
	return vim.tbl_contains(types, kind)
end, { force = true })

query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
	if not valid_args(pred[1], pred, 2) then
		return
	end

	local node = capture_node(match, pred[2])
	local types = { unpack(pred, 3) }

	if not node then
		return true
	end

	return vim.tbl_contains(types, node:type())
end, { force = true })

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
	local node = capture_node(match, pred[2])
	if not node then
		return
	end

	local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
	local configured = html_script_type_languages[type_attr_value]
	if configured then
		metadata["injection.language"] = configured
	else
		local parts = vim.split(type_attr_value, "/", {})
		metadata["injection.language"] = parts[#parts]
	end
end, { force = true })

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
	local node = capture_node(match, pred[2])
	if not node then
		return
	end

	local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
	metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, { force = true })

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
	local id = pred[2]
	local node = capture_node(match, id)
	if not node then
		return
	end

	local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
	if not metadata[id] then
		metadata[id] = {}
	end
	metadata[id].text = string.lower(text)
end, { force = true })
