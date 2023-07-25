local utf8 = require('window-picker.utf-8')

--- @class FloatingBigLetterHint
--- @field win { width: number, height: number } window options
--- @field windows number[] list of window ids
--- @field prefix_windows number[][] list of window ids for the prefix characters
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
		prefix_windows = { {}, {}, {}, {} },
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:set_config(config)
	self.chars = config.chars
	self.create_chars = config.create_chars
	local font = config.picker_config.floating_big_letter.font

	if type(font) == 'string' then
		self.big_chars = require(('window-picker.hints.data.%s'):format(font))
	end

	if type(font) == 'table' then
		self.big_chars = font
	end

	self.window = config.picker_config.floating_big_letter.window
	self.window_config = vim.tbl_deep_extend('force', {
		-- these options are safe to change
		focusable = true,
		border = border,
	}, self.window.config)
end

local positioning_params = {
	m = { 0.5, 0.5, 0.5, 0.5, 'NW' }, -- Middle
	h = { 0, 0, 0.5, 0.5, 'NW' }, -- Middle-left
	j = { 0.5, 0.5, 1, 0, 'SW' }, -- Bottom-middle
	k = { 0.5, 0.5, 0, 0, 'NW' }, -- Top-middle
	l = { 1, 0, 0.5, 0.5, 'NE' }, -- Middle-right
}
local create_win_positions = { 'h', 'j', 'k', 'l' }

function M:_get_float_win_pos(window, position)
	position = position or 'm'
	local width = vim.api.nvim_win_get_width(window)
	local height = vim.api.nvim_win_get_height(window)
	local params = positioning_params[position]

	local point = {
		x = width * params[1] - self.win.width * params[2],
		y = height * params[3] - self.win.height * params[4],
		anchor = params[5],
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

	--left & right paddin

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

function M:_show_letter_in_window(window, char, position)
	local point = self:_get_float_win_pos(window, position)

	local lines = self._add_big_char_margin(vim.split(char, '\n'))

	local width = utf8.len(lines[2])
	local height = #lines

	local buffer_id = vim.api.nvim_create_buf(false, true)
	local window_id = vim.api.nvim_open_win(
		buffer_id,
		false,
		vim.tbl_deep_extend('force', self.window.config, {
			-- these options must not be overridden
			style = 'minimal',
			relative = 'win',
			win = window,
			row = point.y,
			col = point.x,
			width = width,
			height = height,
			anchor = point.anchor,
			focusable = false,
		})
	)

	for opt, val in pairs(self.window.options) do
		vim.api.nvim_set_option_value(opt, val, {
			scope = 'local',
			win = window_id,
		})
	end

	vim.api.nvim_buf_set_lines(buffer_id, 0, 0, true, lines)

	return window_id
end

function M:draw(windows, or_create)
	local include_curwin =
		require('window-picker.config').filter_rules.include_current_win
	local curwin = vim.api.nvim_get_current_win()
	for index, window in ipairs(windows) do
		if include_curwin or (window ~= curwin) then
			local char = self.chars[index]
			local big_char = self.big_chars[char:lower()]
			local window_id = self:_show_letter_in_window(window, big_char)
			table.insert(self.windows, window_id)
		end

		if or_create then
			for i = 1, 4 do
				local char = self.create_chars[i]
				local big_char = self.big_chars[char:lower()]
				local dir = create_win_positions[i]
				local window_id =
					self:_show_letter_in_window(window, big_char, dir)
				table.insert(self.prefix_windows[i], window_id)
			end
		end
	end
end

local function clear_list_of_windows(windows)
	for _, window in ipairs(windows) do
		if vim.api.nvim_win_is_valid(window) then
			local buffer = vim.api.nvim_win_get_buf(window)
			vim.api.nvim_win_close(window, true)
			vim.api.nvim_buf_delete(buffer, { force = true })
		end
	end
end

function M:clear_prefixes(index)
	for prefix, windows in ipairs(self.prefix_windows) do
		-- Clear all prefixes except the one that was chosen
		if prefix ~= index then
			clear_list_of_windows(windows)
			self.prefix_windows[prefix] = {}
		end
	end
end

function M:clear()
	clear_list_of_windows(self.windows)

	self:clear_prefixes()

	self.windows = {}
end

return M
