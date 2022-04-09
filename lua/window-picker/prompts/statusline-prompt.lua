local M = {}
M.__index = M

function M.new()
	local self = setmetatable({}, M)

	self.window_options = {}
	self.laststatus = vim.o.laststatus

	return self
end

function M:set_config(config)
	self.chars = config.chars
	self.current_win_hl_color = config.current_win_hl_color
	self.other_win_hl_color = config.other_win_hl_color
end

-- M:_set_highlight_groups sets highlight groups
-- @param { any } config passes colors
function M:_set_highlight_groups()
	vim.cmd("highlight NvimWindoSwitch gui=bold guifg=#ededed guibg=" .. self.current_win_hl_color)
	vim.cmd("highlight NvimWindoSwitchNC gui=bold guifg=#ededed guibg=" .. self.other_win_hl_color)
end

-- M:_save_window_options saves the initial window options later will be changed
-- @param { Array<number> } window_ids list of window IDs
function M:_save_window_options(windows)
	for _, window in ipairs(windows) do
		self.window_options[window] = {
			statusline = vim.api.nvim_win_get_option(window, "statusline"),
			winhl = vim.api.nvim_win_get_option(window, "winhl"),
		}
	end
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
		vim.api.nvim_win_set_option(window, "statusline", "%=" .. char .. "%=")
		vim.api.nvim_win_set_option(window, "winhl", "StatusLine:NvimWindoSwitch,StatusLineNC:NvimWindoSwitchNC")
	end

	vim.cmd("redraw")
end

-- M:clear the screen after print
function M:clear()
	vim.o.laststatus = self.laststatus

	for window, options in pairs(self.window_options) do
		for option, value in pairs(options) do
			vim.api.nvim_win_set_option(window, option, value)
		end
	end

	self.window_options = {}
end

return M
