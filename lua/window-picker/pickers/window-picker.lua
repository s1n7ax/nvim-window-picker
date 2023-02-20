local util = require('window-picker.util')

---@class WindowPicker
local M = {}

function M:new()
	local o = {}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:set_config(config)
	self.chars = config.chars
	return self
end

function M:set_filter(filter)
	self.filter = filter
	return self
end

function M:set_hint(hint)
	self.hint = hint
	return self
end

function M:_get_windows()
	local all_windows = vim.api.nvim_tabpage_list_wins(0)
	return self.filter:filter_windows(all_windows)
end

function M:_find_matching_win_for_char(user_input_char, windows)
	for index, char in ipairs(self.chars) do
		if user_input_char:lower() == char:lower() then
			return windows[index]
		end
	end
end

function M:pick_window()
	local windows = self:_get_windows()
	local window = nil

	self.hint:draw(windows)

	vim.cmd.redraw()

	local char = util.get_user_input_char()
	self.hint:clear()

	if char then
		window = self:_find_matching_win_for_char(char, windows)
	end

	return window
end

return M
