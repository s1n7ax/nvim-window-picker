local builder = require('window-picker.builder')

local M = {}

function M.pick_window(custom_config)
    builder.new():set_config(custom_config):build():pick_window()
end

return M
