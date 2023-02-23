local dconfig = require('window-picker.config')
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
	self.config = vim.tbl_deep_extend('force', dconfig, config or {})
	return self
end

function M:set_picker(picker)
	self.picker = picker or dpicker:new()
	return self
end

function M:set_hint(hint)
	self.hint = hint or dhint:new()
	return self
end

function M:set_filter(filter)
	self.filter = filter or dfilter:new()
	return self
end

function M:build()
	local configurer = self.configurer or dconfigurer:new(self.config)

	local hint = configurer:config_hint(self.hint)
	local filter = configurer:config_filter(self.filter)
	local picker = configurer:config_picker(self.picker)

	picker:set_filter(filter)
	picker:set_hint(hint)

	return picker
end

return M
