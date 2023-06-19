---@class StatuslineHint
---@field window_options table<string, any> window options
---@field global_options table<string, any> global options
---@field laststatus string current value of the laststatus
---@field chars string[] list of chars to hint
---@field selection_display function function to customize the hint
local M = {}

function M:new()
	local o = {
		window_options = {},
		global_options = {},
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:set_config(config)
	self.chars = config.chars
	self.selection_display =
		config.picker_config.statusline_winbar_picker.selection_display

	vim.api.nvim_set_hl(0, 'WindowPickerStatusLine', {
		fg = '#ededed',
		bg = config.current_win_hl_color,
		bold = true,
	})

	vim.api.nvim_set_hl(0, 'WindowPickerStatusLineNC', {
		fg = '#ededed',
		bg = config.other_win_hl_color,
		bold = true,
	})
end

--- M:_save_window_options saves the initial window options later will be changed
--- @param windows number[]
function M:save_window_options(windows, win_opt_to_cap)
	self.window_options = {}

	for _, window in ipairs(windows) do
		self.window_options[window] = {}

		for _, opt_key in ipairs(win_opt_to_cap) do
			self.window_options[window][opt_key] = vim.wo[window][opt_key]
		end
	end
end

--- Shows the characters in status line
--- @param windows number[] windows to draw the hints on
function M:draw(windows)
	local win_opt_to_cap = { 'statusline', 'winhl' }

	if vim.o.cmdheight < 1 then
		self.global_options['cmdheight'] = vim.o['cmdheight']
		vim.o.cmdheight = 1
	end

	if vim.o.laststatus ~= 2 then
		self.global_options['laststatus'] = vim.o['laststatus']
		vim.o.laststatus = 2
	end

	self:save_window_options(windows, win_opt_to_cap)

	for index, window in ipairs(windows) do
		local char = self.chars[index]

		local display_text = self.selection_display
				and self.selection_display(char, window)
			or '%=' .. char .. '%='

		vim.wo[window].statusline = display_text

		vim.wo[window].winhl =
			'StatusLine:WindowPickerStatusLine,StatusLineNC:WindowPickerStatusLineNC'
	end

	vim.cmd.redraw()
end

--- clear the screen after print
function M:clear()
	for window, options in pairs(self.window_options) do
		for opt_key, opt_value in pairs(options) do
			pcall(vim.api.nvim_win_set_option, window, opt_key, opt_value)
		end
	end

	for key, value in pairs(self.global_options) do
		vim.o[key] = value
	end

	self.window_options = {}
	self.global_options = {}
end

return M
