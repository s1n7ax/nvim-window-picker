---@diagnostic disable-next-line: undefined-global
local v = vim
local M = {}

function M.escape_pattern(text)
    return text:gsub('([^%w])', '%%%1')
end
function M.tbl_filter(tbl, filter_func)
    return v.tbl_filter(filter_func, tbl)
end

function M.tbl_any(tbl, match_func)
    for _, i in ipairs(tbl) do if match_func(i) then return true end end

    return false
end

function M.get_user_input_char()
    local c = v.fn.getchar()
    while type(c) ~= 'number' do c = v.fn.getchar() end
    return v.fn.nr2char(c)
end

function M.clear_prompt()
    v.api.nvim_command('normal :esc<CR>')
end

function M.is_float(window)
    local config = v.api.nvim_win_get_config(window)

    return config.relative ~= ''
end

return M
