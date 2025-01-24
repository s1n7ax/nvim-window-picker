--- @class FloatingLetterHint
--- @field windows number[] list of window ids
local M = {}

local border = {
	{ '╭', 'FloatBorder' },

	{ '─', 'FloatBorder' },

	{ '╮', 'FloatBorder' },

	{ '│', 'FloatBorder' },

	{ '╯', 'FloatBorder' },

	{ '─', 'FloatBorder' },

	{ '╰', 'FloatBorder' },

	{ '│', 'FloatBorder' },
}

function M:new()
	local o = {
		windows = {},
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:set_config(config)
	self.chars = config.chars
end

function M._get_float_win_pos(window, width, height)
	local win_width = vim.api.nvim_win_get_width(window)
	local win_height = vim.api.nvim_win_get_height(window)

	local point = {
		x = ((win_width - width) / 2),
		y = ((win_height - height) / 2),
	}

	return point
end

function M:_show_letter_in_window(window, char)
	local width = #char
	local height = 1
	local point = self._get_float_win_pos(window, width, height)

	local buffer_id = vim.api.nvim_create_buf(false, true)
	local window_id = vim.api.nvim_open_win(buffer_id, false, {
		relative = 'win',
		win = window,
		focusable = true,
		row = point.y,
		col = point.x,
		width = width,
		height = height,
		style = 'minimal',
		border = border,
	})

	vim.api.nvim_buf_set_lines(buffer_id, 0, -1, true, { char })

	return window_id
end

function M:draw(windows)
	for index, window in ipairs(windows) do
		local char = self.chars[index]
		local window_id = self:_show_letter_in_window(window, char)
		table.insert(self.windows, window_id)
	end
end

function M:clear()
	for _, window in ipairs(self.windows) do
		if vim.api.nvim_win_is_valid(window) then
			local buffer = vim.api.nvim_win_get_buf(window)
			vim.api.nvim_win_close(window, true)
			vim.api.nvim_buf_delete(buffer, { force = true })
		end
	end

	self.windows = {}
end

return M
