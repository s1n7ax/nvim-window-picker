local HL = {
	st_hi = 'WindowPickerStatusLine',
	st_hi_nc = 'WindowPickerStatusLineNC',
	wb_hi = 'WindowPickerWinBar',
	wb_hi_nc = 'WindowPickerWinBarNC',
}

local StatuslineHint = require('window-picker.hints.statusline-hint')

---@class StatuslineWinbarHint
---@field window_options table<string, any> window options
---@field global_options table<string, any> global options
---@field chars string[] list of chars to hint
---@field selection_display function function to customize the hint
local M = StatuslineHint:new()

function M:set_config(config)
	self.chars = config.chars
	self.show_prompt = config.show_prompt

	self.selection_display =
		config.picker_config.statusline_winbar_picker.selection_display
	self.use_winbar = config.picker_config.statusline_winbar_picker.use_winbar
	self.hl_namespace = vim.api.nvim_create_namespace('')
	self.should_set_hl_ns = false

	-- registering highlights
	self:create_hl(HL.st_hi, config.highlights.statusline.focused)
	self:create_hl(HL.st_hi_nc, config.highlights.statusline.unfocused)
	self:create_hl(HL.wb_hi, config.highlights.winbar.focused)
	self:create_hl(HL.wb_hi_nc, config.highlights.winbar.unfocused)
end

function M:create_hl(name, properties)
	if type(properties) == 'table' then
		self.should_set_hl_ns = true
		vim.api.nvim_set_hl(self.hl_namespace, name, properties)
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
			use_winbar and HL.wb_hi or HL.st_hi,
			indicator_hl,
			use_winbar and HL.wb_hi_nc or HL.st_hi_nc
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

		-- setting the highlight namespace

		if self.should_set_hl_ns then
			print('setting namespace', window, self.hl_namespace)
			vim.api.nvim_win_set_hl_ns(window, self.hl_namespace)
		end
	end

	vim.cmd.redraw()
end

--- clear the screen after print
function M:clear()
	-- clear window changes
	for window, options in pairs(self.window_options) do
		for opt_key, opt_value in pairs(options) do
			pcall(vim.api.nvim_win_set_option, window, opt_key, opt_value)
		end

		-- removing the namespaces
		vim.api.nvim_win_set_hl_ns(window, 0)
	end

	-- clear global changes
	for key, value in pairs(self.global_options) do
		vim.o[key] = value
	end

	self.window_options = {}
	self.global_options = {}
end

return M
