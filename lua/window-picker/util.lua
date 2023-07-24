local M = {}

function M.escape_pattern(text)
	return text:gsub('([^%w])', '%%%1')
end

function M.tbl_filter(tbl, filter_func)
	return vim.tbl_filter(filter_func, tbl)
end

function M.tbl_any(tbl, match_func)
	for _, i in ipairs(tbl) do
		if match_func(i) then
			return true
		end
	end

	return false
end

function M.map_find(tbl, match_func)
	for key, value in pairs(tbl) do
		if match_func(key, value) then
			return { key, value }
		end
	end
end

function M.get_user_input_char()
	local c = vim.fn.getchar()
	while type(c) ~= 'number' do
		c = vim.fn.getchar()
	end
	return vim.fn.nr2char(c)
end

function M.clear_prompt()
	vim.api.nvim_command('normal :esc<CR>')
end

function M.merge_config(current_config, new_config)
	if not new_config then
		return current_config
	end

	return vim.tbl_deep_extend('force', current_config, new_config)
end

function M.is_float(window)
	local config = vim.api.nvim_win_get_config(window)

	return config.relative ~= ''
end

local getwin = vim.api.nvim_get_current_win
-- split from winid using spl() and return either the new or existing window
-- make sure cursor stays in curwin
---@param winid window
---@param key "h" | "j" | "k" | "k" Direction key to split the window in
local make_split = function(winid, key)
	local opposite = dir == 'k' or dir == 'h'
	local dir = (key == 'k' or key == 'j') and 'below' or 'right'
	local opt = 'split' .. dir
	local id = vim.api.nvim_win_call(winid, function()
		local current = vim.o[opt]
		vim.o[opt] = not opposite
		if dir == 'right' then
			vim.cmd.vsplit()
		else
			vim.cmd.split()
		end
		vim.o[opt] = current
		return getwin()
	end)
	return id
end

M.create_actions = {
	function(winid) -- h
		return make_split(winid, 'h')
	end,
	function(winid) -- j
		return make_split(winid, 'j')
	end,
	function(winid) -- k
		return make_split(winid, 'k')
	end,
	function(winid) -- l
		return make_split(winid, 'l')
	end,
}

return M
