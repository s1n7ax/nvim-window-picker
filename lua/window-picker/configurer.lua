---@class Configurer
---@field config any
local M = {}

function M:new(config)
	config = M._backward_compatibility_config_changes(config)
	config = M._basic_config_manipulations(config)

	local o = {
		config = config,
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M._basic_config_manipulations(config)
	config.chars = M._str_to_char_list(config.selection_chars)
	return config
end

function M._backward_compatibility_config_changes(config)
	----------------------------------------------------------------------
	--                           filter rules                           --
	----------------------------------------------------------------------
	local filter_rules = config.filter_rules

	-- backward compatibility to config.autoselect_one
	if config.autoselect_one then
		filter_rules.autoselect_one = config.autoselect_one
	end

	-- backward compatibility to config.include_current_win
	if config.include_current_win then
		filter_rules.include_current_win = config.include_current_win
	end

	----------------------------------------------------------------------
	--                        highlight changes                         --
	----------------------------------------------------------------------
	if config.current_win_hl_color then
		config.highlights.statusline.focused.bg = config.current_win_hl_color
		config.highlights.winbar.focused.bg = config.current_win_hl_color
	end

	if config.other_win_hl_color then
		config.highlights.statusline.unfocused.bg = config.other_win_hl_color
		config.highlights.winbar.unfocused.bg = config.other_win_hl_color
	end

	----------------------------------------------------------------------
	--                     statusline winbar config                     --
	----------------------------------------------------------------------
	if config.selection_display then
		config.picker_config.statusline_winbar_picker.selection_display =
			config.selection_display
	end

	if config.use_winbar then
		config.picker_config.statusline_winbar_picker.use_winbar =
			config.use_winbar
	end

	return config
end

function M:config_filter(filter)
	if self.config.filter_func then
		filter = {
			filter_windows = function(_, windows)
				return self.config.filter_func(
					windows,
					self.config.filter_rules
				)
			end,
		}

		return filter
	end

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
