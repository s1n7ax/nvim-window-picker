local util = require('window-picker.util')
local dconfig = require('window-picker.config')

local M = {}
M.__index = M

function M.new(config)
    local self = setmetatable({}, M)
    self.config = config and util.merge_config(dconfig, config) or dconfig
    self.config.chars = self:_str_to_char_list(self.config.selection_chars)
    return self
end

function M:config_filter(filter)
    filter:set_config(self.config.filter_rules)
    return filter
end

function M:config_printer(printer)
    printer:set_config(self.config)
    return printer
end

function M:config_picker(picker)
    picker:set_config(self.config)
    return picker
end

function M:_str_to_char_list(str)
	local char_list = {}

	for i = 1, #str do
		table.insert(char_list, str:sub(i,i))
	end

	return char_list
end

return M
