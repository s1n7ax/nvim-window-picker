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
	self.create_chars = config.create_chars
	self.show_prompt = config.show_prompt
	self.prompt_message = config.prompt_message
	self.autoselect_one = config.filter_rules.autoselect_one
	self.or_create = config.or_create
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

function M:_find_matching_win_for_char(user_input_char, windows, create_action)
	for index, char in ipairs(self.chars) do
		if user_input_char:lower() == char:lower() then
			local w = windows[index]
			if create_action then
				return create_action(w)
			else
				return w
			end
		end
	end
end

function M:_find_matching_creation_for_prefix(user_input_char)
	for index, char in ipairs(self.create_chars) do
		if user_input_char:lower() == char:lower() then
			return util.create_actions[index], index
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

	if self.autoselect_one and #windows == 1 and not self.or_create then
		return windows[1]
	end

	self.hint:draw(windows, self.or_create)

	vim.cmd.redraw()

	if self.show_prompt then
		print(self.prompt_message)
	end

	local char = util.get_user_input_char()
	local create_action
	if self.or_create then
		local create_index
		create_action, create_index =
			self:_find_matching_creation_for_prefix(char)
		if create_action then
			self.hint:clear_prefixes(create_index)
			if self.autoselect_one and #windows == 1 then
				char = self.chars[1]
			else
				char = util.get_user_input_char()
			end
		end
	end

	vim.cmd.redraw()

	self.hint:clear()

	local window = nil

	if char then
		window = self:_find_matching_win_for_char(char, windows, create_action)
	end

	return window
end

return M
