local FloatingHint = require('window-picker.hints.floating-big-letter-hint')
local builder = require('window-picker.builder')

local M = {}

function M.pick_window(custom_config)
	return builder
		:new()
		:set_config(custom_config)
		:set_hint(FloatingHint:new())
		:set_picker()
		:set_filter()
		:build()
		:pick_window()
end

function M.setup() end

return M
