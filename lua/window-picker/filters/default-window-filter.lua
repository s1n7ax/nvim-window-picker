local util = require('window-picker.util')

local M = {}
M.__index = M

function M.new()
    local self = setmetatable({}, M)

    self.filter_stack = {
        self._window_option_filter,
        self._buffer_options_filter,
        self._file_path_contains_filter,
        self._file_path_contains_filter,
    }

    return self
end

function M:set_config(config)
    self.window_options = config.wo
    self.buffer_options = config.bo
    self.file_name_contains = config.file_name_contains
    self.file_path_contains = config.file_path_contains
end

function M:filter_windows(windows)
    local filtered_windows = windows

    for _, filter in ipairs(self.filter_stack) do
        filtered_windows = filter(self, filtered_windows)
    end

    return filtered_windows
end

function M:_window_option_filter(windows)
    if self.window_options and vim.tbl_count(self.window_options) > 0 then
        return util.tbl_filter(windows, function(winid)
            for opt_key, opt_values in pairs(self.window_options) do
                local actual_opt = vim.api.nvim_win_get_option(winid, opt_key)

                local has_value = vim.tbl_contains(opt_values, actual_opt)

                if has_value then
                    return false
                end
            end

            return true
        end)
    else
        return windows
    end
end

function M:_buffer_options_filter(windows)
    if self.buffer_options and vim.tbl_count(self.buffer_options) > 0 then
        return util.tbl_filter(windows, function(winid)
            local bufid = vim.api.nvim_win_get_buf(winid)

            for opt_key, opt_values in pairs(self.buffer_options) do
                local actual_opt = vim.api.nvim_buf_get_option(bufid, opt_key)

                local has_value = vim.tbl_contains(opt_values, actual_opt)

                if has_value then
                    return false
                end
            end

            return true
        end)
    else
        return windows
    end
end

function M:_file_path_contains_filter(windows)
    if
        self.file_path_contains
        and vim.tbl_count(self.file_path_contains) > 0
    then
        return util.tbl_filter(windows, function(winid)
            local bufid = vim.api.nvim_win_get_buf(winid)
            local filepath = vim.api.nvim_buf_get_name(bufid)

            local has_match = util.tbl_any(
                self.file_path_contains,
                function(exp_path)
                    exp_path = util.escape_pattern(exp_path)

                    if filepath:find(exp_path) then
                        return true
                    end
                end
            )

            return not has_match
        end)
    else
        return windows
    end
end

function M:_file_name_contains_filter(windows)
    if
        self.file_name_contains
        and vim.tbl_count(self.file_name_contains) > 0
    then
        return util.tbl_filter(windows, function(winid)
            local bufid = vim.api.nvim_win_get_buf(winid)
            local filepath = vim.api.nvim_buf_get_name(bufid)
            local filename = filepath:match('^.*/(.+)$')

            local has_match = util.tbl_any(
                self.file_name_contains,
                function(exp_name)
                    if filename:find(exp_name) then
                        return true
                    end
                end
            )

            return not has_match
        end)
    else
        return windows
    end
end

return M
