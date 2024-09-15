local utf8 = require('window-picker.utf-8')

--- @class FloatingBigLetterHint
--- @field win { width: number, height: number } window options
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
		win = {
			width = 18,
			height = 8,
		},
		windows = {},
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:set_config(config)
	self.chars = config.chars
	local font = config.picker_config.floating_big_letter.font

	if type(font) == 'string' then
		self.big_chars = require(('window-picker.hints.data.%s'):format(font))
	end

	if type(font) == 'table' then
		self.big_chars = font
	end
end

function M:_get_float_win_pos(window)
	local width = vim.api.nvim_win_get_width(window)
	local height = vim.api.nvim_win_get_height(window)

	local point = {
		x = ((width - self.win.width) / 2),
		y = ((height - self.win.height) / 2),
	}

	return point
end

function M._add_big_char_margin(lines)
	local max_text_width = 0
	local centered_lines = {}

	for _, line in ipairs(lines) do
		local len = utf8.len(line)
		if max_text_width < len then
			max_text_width = len
		end
	end

	-- top padding
	table.insert(lines, 1, '')
	--bottom padding
	table.insert(lines, #lines + 1, '')

	--left & right padding

	for _, line in ipairs(lines) do
		local new_line = string.format(
			'%s%s%s',
			string.rep(' ', 2),
			line,
			string.rep(' ', 2)
		)

		table.insert(centered_lines, new_line)
	end

	return centered_lines
end

function M:_show_letter_in_window(window, char)
	local point = self:_get_float_win_pos(window)

	local lines = self._add_big_char_margin(vim.split(char, '\n'))

	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, utf8.len(line))
	end
	local height = #lines

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

	vim.api.nvim_buf_set_lines(buffer_id, 0, -1, true, lines)

	return window_id
end

function M:draw(windows)
	for index, window in ipairs(windows) do
		local char = self.chars[index]
		local big_char = self.big_chars[char:lower()]
		local window_id = self:_show_letter_in_window(window, big_char)
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
