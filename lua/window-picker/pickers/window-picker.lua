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
    return self.filter.filter_windows(all_windows)
end

function M:_find_matching_win_for_char(user_input_char, windows)
    for index, char in ipairs(self.config.chars) do
        if user_input_char == char then
            return windows[index]
        end
    end
end

function M:pick_window()
    local windows = self:_get_windows()
    local window = nil
    self.printer:draw(windows)

    print('Window: ')

    while true do
        local char = vim.fn.getchar()

        if not char then
            break
        end

        window = self:_find_matching_win_for_char(char, windows)
    end

    self.printer:clear()

    return window
end

return M
