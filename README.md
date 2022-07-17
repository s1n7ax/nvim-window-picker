# nvim-window-picker

https://user-images.githubusercontent.com/18459807/161597479-a3d8cf73-3dca-44b1-9eb6-d00b4e6eb842.mp4

This plugins prompts the user to pick a window and returns the window id of the picked window.
Part of the code is from [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua) so shout out to
them for coming up with this idea.

## Install

#### packer

```lua
use {
    's1n7ax/nvim-window-picker',
    tag = 'v1.*',
    config = function()
        require'window-picker'.setup()
    end,
}
```

**Make sure to `:PackerCompile` after installing**

## How to use

```lua
local picked_window_id = require('window-picker').pick_window()
```

**You can put the picked window id to good use**,
for example, set a keymap to switch the current window like this:

```lua
vim.keymap.set("n", "<leader>w", function()
    local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick a window" })
```

## Configuration

If you want to have custom properties just for one time, you can pass any of
following directly to `pick_window()` function itself.

```lua
require 'window-picker'.setup({
    -- when there is only one window available to pick from, use that window
    -- without prompting the user to select
    autoselect_one = true,

    -- whether you want to include the window you are currently on to window
    -- selection or not
    include_current_win = false,

    -- when you go to window selection mode, status bar will show one of
    -- following letters on them so you can use that letter to select the window
    selection_chars = 'FJDKSLA;CMRUEIWOQP',

    -- if you want to manually filter out the windows, pass in a function that
    -- takes two parameters. you should return window ids that should be
    -- included in the selection
    -- EX:-
    -- function(window_ids, filters)
    --    -- filter the window_ids
    --    -- return only the ones you want to include
    --    return {1000, 1001}
    -- end
    filter_func = nil,

    -- following filters are only applied when you are using the default filter
    -- defined by this plugin. if you pass in a function to "filter_func"
    -- property, you are on your own
    filter_rules = {
        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'NvimTree', "neo-tree", "notify" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal' },
        },

        -- filter using window options
        wo = {},

        -- if the file path contains one of following names, the window
        -- will be ignored
        file_path_contains = {},

        -- if the file name contains one of following names, the window will be
        -- ignored
        file_name_contains = {},
    },

    -- the foreground (text) color of the picker
    fg_color = '#ededed',

    -- if you have include_current_win == true, then current_win_hl_color will
    -- be highlighted using this background color
    current_win_hl_color = '#e35e4f',

    -- all the windows except the curren window will be highlighted using this
    -- color
    other_win_hl_color = '#44cc41',
})
```

```lua
require(package_name).pick_window({
    include_current_win = true,
    selection_chars = '123345',
    filter_rules = {
        bo = {
            filetype = {'markdown'}
        }
    },
})
```
