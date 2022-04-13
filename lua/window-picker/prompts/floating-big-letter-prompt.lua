local M = {}
M.__index = M

local border = {
    { '╭', 'FloatBorder' },

    { '─', 'FloatBorder' },

    { '╮', 'FloatBorder' },

    { '│', 'FloatBorder' },

    { '╯', 'FloatBorder' },

    { '─', 'FloatBorder' },

    { '╰', 'FloatBorder' },

    { '│', 'FloatBorder' },
}

function M.new()
    local self = setmetatable({}, M)
    self.win = {
        width = 18,
        height = 8,
    }
    self.windows = {}
    return self
end

function M:set_config(config)
    self.chars = config.chars
end

function M:_get_float_win_pos(window)
    local width = vim.api.nvim_win_get_width(window)
    local height = vim.api.nvim_win_get_height(window)

    local point = {
        x = ((width - self.win.width) / 2),
        y = ((height - self.win.height) / 2),
    }

    return point
end

function M:_show_letter_in_window(window, char)
    local point = self:_get_float_win_pos(window)
    local buffer_id = vim.api.nvim_create_buf(false, true)
    local window_id = vim.api.nvim_open_win(buffer_id, false, {
        relative = 'win',
        win = window,
        focusable = true,
        row = point.y,
        col = point.x,
        width = self.win.width,
        height = self.win.height,
        style = 'minimal',
        border = border,
    })

    vim.api.nvim_buf_set_lines(buffer_id, 0, 0, true, vim.split(char, '\n'))

    return window_id
end

function M:draw(windows)
    for index, window in ipairs(windows) do
        local char = self.chars[index]
        local window_id = self:_show_letter_in_window(window, char)
        table.insert(self.windows, window_id)
    end
end

function M:clear()
    for _, window in ipairs(self.windows) do
        if vim.api.nvim_win_is_valid(window) then
            local buffer = vim.api.nvim_win_get_buf(window)
            vim.api.nvim_buf_delete(buffer, { force = true })
            -- vim.api.nvim_win_close(window, true)
        end
    end

    self.windows = {}
end

return M
