local config = require('window-picker.config')
local util = require('window-picker.util')

local M = {}

M.setup_completed = false

---@diagnostic disable-next-line: undefined-global
local v = vim
local api = v.api

function M.filter_windows(window_ids, filters)
    -- window id filter
    window_ids = util.tbl_filter(
                     window_ids, function(winid)
            return not (v.tbl_contains(filters.window_ids, winid))
        end)

    -- window option filter
    if v.tbl_count(filters.wo) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)

                for opt_key, opt_values in pairs(filters.wo) do
                    local actual_opt = api.nvim_win_get_option(winid, opt_key)

                    local has_value = v.tbl_contains(opt_values, actual_opt)

                    if has_value then return false end
                end

                return true
            end)
    end

    -- buffer option filter
    if v.tbl_count(filters.bo) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)
                local bufid = api.nvim_win_get_buf(winid)

                for opt_key, opt_values in pairs(filters.bo) do
                    local actual_opt = api.nvim_buf_get_option(bufid, opt_key)

                    local has_value = v.tbl_contains(opt_values, actual_opt)

                    if has_value then return false end
                end

                return true
            end)
    end

    -- file path filter
    if v.tbl_count(filters.file_path_contains) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)
                local bufid = api.nvim_win_get_buf(winid)
                local filepath = api.nvim_buf_get_name(bufid)

                local has_match = util.tbl_any(
                                      filters.file_path_contains,
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
    if v.tbl_count(filters.file_name_contains) > 0 then
        window_ids = util.tbl_filter(
                         window_ids, function(winid)
                local bufid = api.nvim_win_get_buf(winid)
                local filepath = api.nvim_buf_get_name(bufid)
                local filename = filepath:match('^.*/(.+)$')

                local has_match = util.tbl_any(
                                      filters.file_name_contains,
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

function M.pick_window(custom_config)
    if not M.setup_completed then
        error(
            'nvim-window-selector: you should first call setup() when loading the plugin')
    end

    -- just preventing changes in global config
    local conf = config

    if custom_config then
        conf = v.tbl_deep_extend('force', conf, custom_config)

        -- setting highlight groups
        v.cmd(
            'highlight NvimWindoSwitch gui=bold guifg=#ededed guibg=' ..
                config.current_win_hl_color)
        v.cmd(
            'highlight NvimWindoSwitchNC gui=bold guifg=#ededed guibg=' ..
                config.other_win_hl_color)
    end

    -- whether to include the current window to the list
    if not config.include_current_win then
        local winnr = api.nvim_get_current_win()
        table.insert(conf.filter_rules.window_ids, winnr)
    end

    local window_ids = api.nvim_list_wins()
    local selectable = conf.filter_func(window_ids, conf.filter_rules)

    -- If there are no selectable windows, return
    if #selectable == 0 then return -1 end

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
        for opt, value in pairs(win_opts[id]) do
            api.nvim_win_set_option(id, opt, value)
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

    -- setting highlight groups
    v.cmd(
        'highlight NvimWindoSwitch gui=bold guifg=#ededed guibg=' ..
            config.current_win_hl_color)
    v.cmd(
        'highlight NvimWindoSwitchNC gui=bold guifg=#ededed guibg=' ..
            config.other_win_hl_color)

    if not config.filter_func then config.filter_func = M.filter_windows end

    M.setup_completed = true
end

return M
