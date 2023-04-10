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
local make_split = function(winid, split, new)
	local id = vim.api.nvim_win_call(winid, function()
		split()
		return new and getwin() or winid
	end)
	return id
end
M.create_actions = {
	function(winid) -- h
		return make_split(winid, vim.cmd.vsplit, false)
	end,
	function(winid) -- j
		return make_split(winid, vim.cmd.split, true)
	end,
	function(winid) -- k
		return make_split(winid, vim.cmd.split, false)
	end,
	function(winid) -- l
		return make_split(winid, vim.cmd.vsplit, true)
	end,
}

return M
