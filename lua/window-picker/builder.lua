local dfilter = require('window-picker.filters.default-window-filter')
local dpicker = require('window-picker.pickers.window-picker')
local dprompt = require('window-picker.prompts.statusline-prompt')
local dconfigurer = require('window-picker.configurer')

local M = {}
M.__index = M

function M.new(configurer)
    local self = setmetatable({}, M)
    self.configurer = configurer
    return self
end

function M:set_config(config)
    self.config = config
    return self
end

function M:set_picker(picker)
    self.picker = picker or dpicker.new()
    return self
end

function M:set_printer(printer)
    self.printer = printer or dprompt.new()
    return self
end

function M:set_filter(filter)
    self.filter = filter or dfilter.new()
    return self
end

function M:build()
    local configurer = self.configurer or dconfigurer.new(self.config)

    local printer = configurer:config_printer(self.printer)
    local filter = configurer:config_filter(self.filter)
    local picker = configurer:config_picker(self.picker)

    picker:set_filter(filter)
    picker:set_printer(printer)

    return picker
end

return M
