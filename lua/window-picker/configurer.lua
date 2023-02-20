local util = require('window-picker.util')
local dconfig = require('window-picker.config')

---@class Configurer
---@field config any
local M = {}

function M:new(config)
	local o = {
		config = config and util.merge_config(dconfig, config) or dconfig,
	}

	o.config.chars = self._str_to_char_list(
		o.config.selection_chars
	)

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:config_filter(filter)
	filter:set_config(self.config.filter_rules)
	return filter
end

function M:config_hint(hint)
	hint:set_config(self.config)
	return hint
end

function M:config_picker(picker)
	picker:set_config(self.config)
	return picker
end

function M._str_to_char_list(str)
	local char_list = {}

	for i = 1, #str do
		table.insert(char_list, str:sub(i, i))
	end

	return char_list
end

return M
