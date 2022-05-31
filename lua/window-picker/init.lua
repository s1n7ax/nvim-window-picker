local config = require('window-picker.config')
local util = require('window-picker.util')

local M = {}

M.setup_completed = false

---@diagnostic disable-next-line: undefined-global
local v = vim
local api = v.api

--[[
-- Retures window id after filtering them using given rules
-- IF no windows passed, function will use all available windows in the current
-- session
-- @param @optional filter_rules { Map } filters. check
-- "nvim-window-picker.config.filter_rules" for more
-- information.
-- IF the filter_rules were not passed, function will use global
-- configurations
-- @returns { Array<number> } list of window IDs after filtering
--]]
function M.filter_windows(window_ids, filter_rules)
    window_ids = window_ids or api.nvim_tabpage_list_wins(0)
    filter_rules = filter_rules or config.filter_rules

    -- removing floating windows from the list
    window_ids = util.tbl_filter(window_ids, function(winid)
        return not util.is_float(winid)
    end)

    -- window option filter
    if filter_rules.wo and v.tbl_count(filter_rules.wo) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)

                for opt_key, opt_values in pairs(filter_rules.wo) do
                    local actual_opt = api.nvim_win_get_option(winid, opt_key)

                    local has_value = v.tbl_contains(opt_values, actual_opt)

                    if has_value then return false end
                end

                return true
            end)
    end

    -- buffer option filter
    if filter_rules.bo and v.tbl_count(filter_rules.bo) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)
                local bufid = api.nvim_win_get_buf(winid)

                for opt_key, opt_values in pairs(filter_rules.bo) do
                    local actual_opt = api.nvim_buf_get_option(bufid, opt_key)

                    local has_value = v.tbl_contains(opt_values, actual_opt)

                    if has_value then return false end
                end

                return true
            end)
    end

    -- file path filter
    if filter_rules.file_path_contains and
        v.tbl_count(filter_rules.file_path_contains) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)
                local bufid = api.nvim_win_get_buf(winid)
                local filepath = api.nvim_buf_get_name(bufid)

                local has_match = util.tbl_any(
                                      filter_rules.file_path_contains,
                                      function(exp_path)

                        exp_path = util.escape_pattern(exp_path)

                        if filepath:find(exp_path) then
                            return true
                        end
                    end)

                return not (has_match)
            end)
    end

    -- file name filter
    if filter_rules.file_name_contains and
        v.tbl_count(filter_rules.file_name_contains) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)
                local bufid = api.nvim_win_get_buf(winid)
                local filepath = api.nvim_buf_get_name(bufid)
                local filename = filepath:match('^.*/(.+)$')

                local has_match = util.tbl_any(
                                      filter_rules.file_name_contains,
                                      function(exp_name)
                        if filename:find(exp_name) then
                            return true
                        end
                    end)

                return not (has_match)
            end)
    end

    return window_ids
end

--[[
-- Prompts the user to select a window and returns the selected window
--
-- @param @optional custom_config { Map } configuration to use for the pick.
-- please refer "nvim-window-picker.config.lua" for available config
-- IF no parameters were passed, this will use the global configuration
--]]
function M.pick_window(custom_config)
    if not M.setup_completed then
        error(
            'nvim-window-selector: you should first call setup() when loading the plugin')
    end

    local conf = config

    if custom_config then
        conf = v.tbl_deep_extend('force', conf, custom_config)
    end

    -- setting highlight groups
    -- NOTE: somethig clears out the highlights so this needs to be in pick
    -- window function
    v.cmd(
        ('highlight NvimWindoSwitch gui=bold guifg=%s guibg=%s'):format(conf.fg_color, conf.current_win_hl_color)
    )
    v.cmd(
        ('highlight NvimWindoSwitchNC gui=bold guifg=%s guibg=%s'):format(conf.fg_color, conf.other_win_hl_color)
    )

    local selectable = nil

    if conf.filter_func then
        selectable = conf.filter_func(api.nvim_tabpage_list_wins(0), conf)
    else
        selectable = M.filter_windows()
    end

    -- whether to include the current window to the list
    if not conf.include_current_win then
        selectable = util.tbl_filter(
                         selectable, function(winid)
                local curr_win = api.nvim_get_current_win()
                if winid == curr_win then return false end

                return true
            end)
    end

    -- If there are no selectable windows, return
    if #selectable == 0 then return nil end

    if conf.autoselect_one and v.tbl_count(selectable) == 1 then
        return selectable[1]
    end

    local chars = conf.selection_chars

    local win_opts = {}
    local win_map = {}
    local laststatus = v.o.laststatus
    v.o.laststatus = 2

    -- Setup UI
    for i, id in ipairs(selectable) do
        local char = chars:sub(i, i)
        local ok_status, statusline = pcall(
                                          api.nvim_win_get_option, id,
                                          'statusline')
        local ok_hl, winhl = pcall(api.nvim_win_get_option, id, 'winhl')

        win_opts[id] = {
            statusline = ok_status and statusline or '',
            winhl = ok_hl and winhl or '',
        }

        win_map[char] = id

        api.nvim_win_set_option(id, 'statusline', '%=' .. char .. '%=')

        api.nvim_win_set_option(
            id, 'winhl',
            'StatusLine:NvimWindoSwitch,StatusLineNC:NvimWindoSwitchNC')
    end

    v.cmd('redraw')
    print('Pick window: ')
    local _, resp = pcall(util.get_user_input_char)
    resp = (resp or ''):upper()
    util.clear_prompt()

    -- Restore window options
    for _, id in ipairs(selectable) do
        if api.nvim_win_is_valid(id) then
            for opt, value in pairs(win_opts[id]) do
                api.nvim_win_set_option(id, opt, value)
            end
        end
    end

    v.o.laststatus = laststatus

    return win_map[resp]
end

function M.setup(custom_config)
    -- merge configurations
    if custom_config then
        config = v.tbl_deep_extend('force', config, custom_config)
    end

    M.setup_completed = true
end

return M
