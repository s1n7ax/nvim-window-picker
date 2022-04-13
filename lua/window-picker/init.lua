local prompt = require('window-picker.prompts.floating-big-letter-prompt')
local builder = require('window-picker.builder')

local M = {}

function M.pick_window(custom_config)
    return builder.new()
        :set_config(custom_config)
        :set_picker()
        :set_printer(prompt.new())
        :set_filter()
        :build()
        :pick_window()
end

function M.setup() end

return M
