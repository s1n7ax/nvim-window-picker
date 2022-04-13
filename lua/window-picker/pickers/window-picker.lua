local util = require('window-picker.util')

local M = {}
M.__index = M

function M.new()
    return setmetatable({}, M)
end

function M:set_config(config)
    self.chars = config.chars
    return self
end

function M:set_filter(filter)
    self.filter = filter
    return self
end

function M:set_printer(printer)
    self.printer = printer
    return self
end

function M:_get_windows()
    local all_windows = vim.api.nvim_tabpage_list_wins(0)
    return self.filter:filter_windows(all_windows)
end

function M:_find_matching_win_for_char(user_input_char, windows)
    for index, char in ipairs(self.chars) do
        if user_input_char:lower() == char:lower() then
            return windows[index]
        end
    end
end

function M:pick_window()
    local windows = self:_get_windows()
    local window = nil
    local char = nil

    self.printer:draw(windows)

    local select_window = vim.schedule_wrap(function()
        char = util.get_user_input_char()
        self.printer:clear()
    end)

    select_window()

    if char then
        window = self:_find_matching_win_for_char(char, windows)
    end

    return window
end

return M
