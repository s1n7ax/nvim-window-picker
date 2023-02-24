local StatuslineHint = require('window-picker.hints.statusline-hint')

---@class StatuslineWinbarHint
---@field window_options table<string, any> window options
---@field global_options table<string, any> global options
---@field chars string[] list of chars to hint
---@field selection_display function function to customize the hint
local M = StatuslineHint:new()

function M:set_config(config)
	self.chars = config.chars
	self.selection_display = config.selection_display
	self.use_winbar = config.use_winbar
	self.show_prompt = config.show_prompt

	-- registering highlights
	if type(config.highlights.statusline.focused) == 'table' then
		self.st_hi = 'WindowPickerStatusLine'
		vim.api.nvim_set_hl(0, self.st_hi, config.highlights.statusline.focused)
	end

	if type(config.highlights.statusline.unfocused) == 'table' then
		self.st_hi_nc = 'WindowPickerStatusLineNC'
		vim.api.nvim_set_hl(
			0,
			self.st_hi_nc,
			config.highlights.statusline.unfocused
		)
	end

	if type(config.highlights.winbar.focused) == 'table' then
		self.wb_hi = 'WindowPickerWinBar'
		vim.api.nvim_set_hl(
			0,
			self.wb_hi,
			config.highlights.statusline.unfocused
		)
	end

	if type(config.highlights.winbar.unfocused) == 'table' then
		self.wb_hi_nc = 'WindowPickerWinBarNC'
		vim.api.nvim_set_hl(
			0,
			self.wb_hi_nc,
			config.highlights.statusline.unfocused
		)
	end
end

--- Shows the characters in status line
--- @param windows number[] windows to draw the hints on
function M:draw(windows)
	local use_winbar = false

	-- calculate if we should use winbar or not
	if self.use_winbar == 'always' then
		use_winbar = true
	elseif self.use_winbar == 'never' then
		use_winbar = false
	elseif self.use_winbar == 'smart' then
		use_winbar = vim.o.cmdheight == 0
	end

	local indicator_setting = use_winbar and 'winbar' or 'statusline'
	local indicator_hl = use_winbar and 'WinBar' or 'StatusLine'

	if not use_winbar then
		if vim.o.laststatus ~= 2 then
			self.global_options['laststatus'] = vim.o['laststatus']
			vim.o.laststatus = 2
		end

		if self.show_prompt and vim.o.cmdheight < 1 then
			self.global_options['cmdheight'] = vim.o['cmdheight']
			vim.o.cmdheight = 1
		end
	end

	local win_opt_to_cap = { indicator_setting, 'winhl' }
	self:save_window_options(windows, win_opt_to_cap)

	for index, window in ipairs(windows) do
		local char = self.chars[index]
		local display_text = self.selection_display
				and self.selection_display(char, window)
			or '%=' .. char .. '%='

		local winhl = string.format(
			'%s:%s,%sNC:%s',
			indicator_hl,
			use_winbar and self.wb_hi or self.st_hi,
			indicator_hl,
			use_winbar and self.wb_hi_nc or self.wb_hi
		)

		local ok, result = pcall(
			vim.api.nvim_win_set_option,
			window,
			indicator_setting,
			display_text
		)

		if not ok then
			local buffer = vim.api.nvim_win_get_buf(window)
			local message = 'Unable to set '
				.. indicator_setting
				.. ' for window id::'
				.. window
				.. '\n'
				.. 'filetype::'
				.. vim.bo[buffer]['filetype']
				.. '\n'
				.. 'consider ignoring unwanted windows using filter options\n'
				.. 'actual error\n'
				.. result

			vim.notify(message, vim.log.levels.WARN)
		end

		--  pcall(vim.api.nvim_win_set_option, window, 'winhl', winhl)
		vim.wo[window]['winhl'] = winhl
	end

	vim.cmd.redraw()
end

return M
