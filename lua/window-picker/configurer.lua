local util = require('window-picker.util')
local dconfig = require('window-picker.config')

local M = {}
M.__index = M

function M.new(config)
    local self = setmetatable({}, M)
    self.config = config and util.merge_config(dconfig, config) or dconfig
    return self
end

function M:config_filter(filter)
    filter:set_config(self.config)
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

return M
