local dfilter = require('window-picker.filters.default-window-filter')
local dpicker = require('window-picker.pickers.window-picker')
local dhint = require('window-picker.hints.statusline-winbar-hint')
local dconfigurer = require('window-picker.configurer')

--- @class DefaultBuilder
--- @field configurer Configurer
local M = {}

function M:new(configurer)
	local o = { configurer = configurer }

	setmetatable(o, self)
	self.__index = self

	return self
end

function M:set_config(config)
	self.config = config
	return self
end

function M:set_picker(picker)
	self.picker = picker
	return self
end

function M:set_hint(hint)
	self.hint = hint
	return self
end

function M:set_filter(filter)
	self.filter = filter
	return self
end

function M:build()
	local configurer = self.configurer or dconfigurer:new(self.config)

	local hint = configurer:config_hint(self.hint or dhint:new())
	local filter = configurer:config_filter(self.filter or dfilter:new())
	local picker = configurer:config_picker(self.picker or dpicker:new())

	picker:set_filter(filter)
	picker:set_hint(hint)

	return picker
end

return M
