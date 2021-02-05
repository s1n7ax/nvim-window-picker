# Neovim-Lua Plugin Development Beginner's Guide

## Before we start

* Neovim Lua boilerplate: https://github.com/s1n7ax/neovim-lua-plugin-boilerplate
* Neovim Lua video tutorials: https://youtube.com/playlist?list=PL0EgBggsoPCk1WCos2txThsxhg0fT5nqD
* My Neovim configuration: https://github.com/s1n7ax/dotnvim
* Terminal manager: https://github.com/s1n7ax/nvim-terminal

## Prerequisites

* Neovim 0.5 or higher version
* Git
* GitHub Account

## Setting up the project

* Create GitHub project
* Clone the project

```bash
git clone <repo>
```

* Open Neovim for editing

```
# NOTE: make sure to add current directory to runtime path
# otherwise, Neovim does not know how to find your plugin
nvim --cmd "set rtp+=."
```

* Create Lua module in Lua source directory

```bash
mkdir -p lua/greetings
```

* Create init file and sub modules for the module

```bash
touch lua/greetings/init.lua
touch lua/greetings/awesome-module.lua
```

## Create greetings plugin

* Add greet function to `awesome-module.lua`

```lua
local function greet()
    print('testing')
end

return greet
```

* Expose public APIs of the plugin

```lua
local greet = require('greetings.awesome-module')

return {
    greet = greet
}
```

* Testing plugin APIs

```vim
# you should run this in the vim command line
:lua require('greetings').greet()
```

## Few tips when developing plugins

### See changes without re opening Neovim

Lua will not reload module if it already exists. The changes you made will be
applied the next time you open the editor. But you can force Lua to reload the
module for development.

* Create `dev/init.lua` file

```bash
mkdir -p dev
touch dev/init.lua
```

* Add following to `dev/init.lua` to force reloading

```
-- force lua to import the modules again
package.loaded['dev'] = nil
package.loaded['greetings'] = nil
package.loaded['greetings.awesome-module'] = nil

-- [ , + r ] keymap to reload the lua file
-- NOTE: someone need to source this file to apply these configurations. So, the
-- very first time you open the project, you have to source this file using
-- ":luafile dev/init.lua". From that point onward, you can hit the keybind to
-- reload
vim.api.nvim_set_keymap('n', ',r', '<cmd>luafile dev/init.lua<cr>', {})
```

* While we are in the file, lets add shortcut to run the greeting plugin

```lua
-- keybind to test the plugin
Greetings = require('greetings')
vim.api.nvim_set_keymap('n', ',w', '<cmd>lua Greetings.greet()<cr>', {})
```


## Learn more about Neovim-Lua

* I release a video on YouTube once a year XD. [This is the link to playlist.](https://youtube.com/playlist?list=PL0EgBggsoPCk1WCos2txThsxhg0fT5nqD) You can subscribe to the channel too ;)
* [nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide) is awesome place
  to start learning Neovim-Lua APIs
* Run `:h api` in Neovim to get all available Neovim-Lua APIs
* Run `:h function` to learn about vim functions. You can run vim functions
  using `vim.fn.<function_name>()`
* Use [Neovim subreddit](https://www.reddit.com/r/neovim) to stay updated and ask questions
