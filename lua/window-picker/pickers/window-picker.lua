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
	self.show_prompt = config.show_prompt
	self.prompt_message = config.prompt_message
	self.autoselect_one = config.filter_rules.autoselect_one
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

	if #windows == 0 then
		vim.notify(
			'No windows left to pick after filtering',
			vim.log.levels.WARN
		)
		return
	end

	if self.autoselect_one and #windows == 1 then
		return windows[1]
	end

	local window = nil

	self.hint:draw(windows)

	vim.cmd.redraw()

	if self.show_prompt then
		print(self.prompt_message)
	end

	local char = util.get_user_input_char()

	vim.cmd.redraw()

	self.hint:clear()

	if char then
		window = self:_find_matching_win_for_char(char, windows)
	end

	return window
end

return M
