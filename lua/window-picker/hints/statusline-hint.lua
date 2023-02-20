---@class StatuslineHint
---@field window_options table<string, any> window options
---@field global_options table<string, any> global options
---@field laststatus string current value of the laststatus
local M = {}

function M:new()
	local o = {
		window_options = {},
		global_options = {},
		laststatus = vim.o.laststatus,
	}

	setmetatable(o, M)
	self.__index = self

	return o
end

function M:set_config(config)
	self.chars = config.chars
	self.current_win_hl_color = config.current_win_hl_color
	self.other_win_hl_color = config.other_win_hl_color
end

-- M:_set_highlight_groups sets highlight groups
-- @param { any } config passes colors
function M:_set_highlight_groups()
	vim.cmd(
		'highlight NvimWindoSwitch gui=bold guifg=#ededed guibg='
			.. self.current_win_hl_color
	)
	vim.cmd(
		'highlight NvimWindoSwitchNC gui=bold guifg=#ededed guibg='
			.. self.other_win_hl_color
	)
end

-- M:_save_window_options saves the initial window options later will be changed
-- @param { Array<number> } window_ids list of window IDs
function M:_save_window_options(windows)
	for _, window in ipairs(windows) do
		self.window_options[window] = {
			statusline = vim.wo[window].statusline,
			winhl = vim.wo[window].winhl,
		}
	end

	self.global_options['cmdheight'] = vim.o.cmdheight
end

-- M:print shows the characters in status line
-- @param { table } data window-letter mapping to show on status line
function M:draw(windows)
	self:_save_window_options(windows)
	self:_set_highlight_groups()

	-- make sure every window has status line
	vim.o.laststatus = 2

	for index, window in ipairs(windows) do
		local char = self.chars[index]
		vim.wo[window].statusline = '%=' .. char .. '%='
		vim.wo[window].winhl =
			'StatusLine:NvimWindoSwitch,StatusLineNC:NvimWindoSwitchNC'
	end

	if self.global_options.cmdheight == 0 then
		vim.o.cmdheight = 1
	end

	vim.cmd('redraw')
end

-- M:clear the screen after print
function M:clear()
	vim.o.laststatus = self.laststatus

	for window, options in pairs(self.window_options) do
		for opt_key, opt_value in pairs(options) do
			vim.wo[window][opt_key] = opt_value
		end
	end

	self.window_options = {}

	for key, value in pairs(self.global_options) do
		vim.o[key] = value
	end
end

return M
