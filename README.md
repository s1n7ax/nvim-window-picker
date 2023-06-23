# nvim-window-picker

`hint = 'floating-big-letter'`

https://github.com/s1n7ax/nvim-window-picker/assets/18459807/8a6a57e2-8be0-4385-88a9-f49c6a088627

`hint = 'statusline-winbar'`

https://github.com/s1n7ax/nvim-window-picker/assets/18459807/8d9a790b-cbcb-455d-8d74-97c55b3cc9b0

This plugins prompts the user to pick a window and returns the window id of the
picked window.

## Install

### lazy

```lua
{
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
        require'window-picker'.setup()
    end,
}
```

### packer

```lua
use {
    's1n7ax/nvim-window-picker',
    tag = 'v2.*',
    config = function()
        require'window-picker'.setup()
    end,
}
```

## How to use

```lua
local picked_window_id = require('window-picker').pick_window()
```

You can put the picked window id to good use

## Configuration

If you want to have custom properties just for one time, you can pass any of
following directly to `pick_window()` function itself to override the default
behaviour.

```lua
require 'window-picker'.setup({
    -- type of hints you want to get
    -- following types are supported
    -- 'statusline-winbar' | 'floating-big-letter'
    -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
    -- 'floating-big-letter' draw big letter on a floating window
    -- used
    hint = 'statusline-winbar',

    -- when you go to window selection mode, status bar will show one of
    -- following letters on them so you can use that letter to select the window
    selection_chars = 'FJDKSLA;CMRUEIWOQP',

    -- This section contains picker specific configurations
    picker_config = {
        statusline_winbar_picker = {
            -- You can change the display string in status bar.
            -- It supports '%' printf style. Such as `return char .. ': %f'` to display
            -- buffer file path. See :h 'stl' for details.
            selection_display = function(char, windowid)
                return '%=' .. char .. '%='
            end,

            -- whether you want to use winbar instead of the statusline
            -- "always" means to always use winbar,
            -- "never" means to never use winbar
            -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
            use_winbar = 'never', -- "always" | "never" | "smart"
        },

        floating_big_letter = {
            -- window picker plugin provides bunch of big letter fonts
            -- fonts will be lazy loaded as they are being requested
            -- additionally, user can pass in a table of fonts in to font
            -- property to use instead

            font = 'ansi-shadow', -- ansi-shadow |
        },
    },

    -- whether to show 'Pick window:' prompt
    show_prompt = true,

    -- prompt message to show to get the user input
    prompt_message = 'Pick window: ',

    -- if you want to manually filter out the windows, pass in a function that
    -- takes two parameters. You should return window ids that should be
    -- included in the selection
    -- EX:-
    -- function(window_ids, filters)
    --    -- folder the window_ids
    --    -- return only the ones you want to include
    --    return {1000, 1001}
    -- end
    filter_func = nil,

    -- following filters are only applied when you are using the default filter
    -- defined by this plugin. If you pass in a function to "filter_func"
    -- property, you are on your own
    filter_rules = {
        -- when there is only one window available to pick from, use that window
        -- without prompting the user to select
        autoselect_one = true,

        -- whether you want to include the window you are currently on to window
        -- selection or not
        include_current_win = false,

        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'NvimTree', 'neo-tree', 'notify' },

            -- if the file type is one of following, the window will be ignored
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

    -- You can pass in the highlight name or a table of content to set as
    -- highlight
    highlights = {
        statusline = {
            focused = {
                fg = '#ededed',
                bg = '#e35e4f',
                bold = true,
            },
            unfocused = {
                fg = '#ededed',
                bg = '#44cc41',
                bold = true,
            },
        },
        winbar = {
            focused = {
                fg = '#ededed',
                bg = '#e35e4f',
                bold = true,
            },
            unfocused = {
                fg = '#ededed',
                bg = '#44cc41',
                bold = true,
            },
        },
    },
})
```

```lua
require('window-picker').pick_window({
    hint = 'floating-big-letter'
})
```

## Theming

If you just want to define the colors using Neovim Highlights, then it's totally
possible. You can set following highlights manually.

- `WindowPickerStatusLine` (currently focused window statusline highlights)
- `WindowPickerStatusLineNC` (currently unfocused window statusline highlights)
- `WindowPickerWinBar` (currently focused window winbar highlights)
- `WindowPickerWinBarNC` (currently unfocused window winbar highlights)

## Breaking changes in v2.0.0

_Before_: return value from `selection_display` will be wrapped by `'%='` and
`'%='` to fill the empty space of status line or winbar.

_After_: return value of `selection_display` will be passed directly to the
status line or winbar. This allows all the customizations available from
statusline syntax. You can check `:help statusline` for more info.
